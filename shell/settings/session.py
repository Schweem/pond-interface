#!/usr/bin/env python3
"""Run session actions, using Pond's confirmed session lock before suspend."""
from pathlib import Path
import os
import subprocess
import sys
import time


def run(action, *cover):
    if action in ('reboot', 'shutdown'):
        subprocess.run(['systemctl', 'reboot' if action == 'reboot' else 'poweroff'], check=True)
        return
    if action not in ('lock', 'suspend'):
        raise ValueError('Unsupported session action')
    method = 'lock' if action == 'lock' else 'lockAndSuspend'
    # A lock can open under the shell's cover: fill, edge, screen, x, y.
    # Lockscreens without lockFrom lock plainly.
    calls = [('lockFrom', *cover), (method,)] if action == 'lock' and cover else [(method,)]
    installed = Path('/usr/share/pond-interface/lockscreen')
    local = Path(__file__).resolve().parents[2] / 'lockscreen'
    # Reuse an existing source or installed instance before starting one; the
    # fork's own lockscreen comes first.
    paths = list(dict.fromkeys((local, installed)))
    for path in paths:
        if request(path, calls):
            break
    else:
        path = local if local.is_dir() else installed
        # Start it unlocked so the lock goes through the same calls.
        subprocess.run(['qs', '-d', '-p', str(path)], check=True,
                       env={**os.environ, 'POND_LOCK_NO_START': '1'})
        if not retry(lambda: request(path, calls)):
            raise RuntimeError('Pond lockscreen did not start' +
                               ('; refusing to suspend' if action == 'suspend' else ''))
    # A lock exits once it is secure, so a cover over the screen can clear.
    if action == 'lock' and not retry(lambda: call(path, 'isSecure').stdout.strip() == 'true'):
        raise RuntimeError('Pond lockscreen did not confirm the lock')


def request(path, calls):
    return any(call(path, *args).returncode == 0 for args in calls)


def call(path, method, *args):
    return subprocess.run(['qs', '-p', str(path), 'ipc', 'call', 'lockscreen', method, *args],
                          capture_output=True, text=True)


def retry(check):
    for _ in range(30):
        if check():
            return True
        time.sleep(0.1)
    return False


if __name__ == '__main__':
    run(*sys.argv[1:])
