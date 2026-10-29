#!/usr/bin/env python3
"""Run session actions, using Pond's confirmed session lock before suspend."""
from pathlib import Path
import subprocess
import sys
import time


def run(action):
    if action in ('reboot', 'shutdown'):
        subprocess.run(['systemctl', 'reboot' if action == 'reboot' else 'poweroff'], check=True)
        return
    if action not in ('lock', 'suspend'):
        raise ValueError('Unsupported session action')
    method = 'lock' if action == 'lock' else 'lockAndSuspend'
    installed = Path('/usr/share/pond-interface/lockscreen')
    local = Path(__file__).resolve().parents[2] / 'lockscreen'
    # Reuse an existing installed or source instance before starting one.
    paths = list(dict.fromkeys((installed, local)))
    for path in paths:
        if call(path, method).returncode == 0:
            break
    else:
        path = installed if installed.is_dir() else local
        subprocess.run(['qs', '-d', '-p', str(path)], check=True)
        if action == 'suspend' and not retry(lambda: call(path, method).returncode == 0):
            raise RuntimeError('Pond lockscreen did not start; refusing to suspend')
    # A lock exits once it is secure, so a cover over the screen can clear.
    if action == 'lock' and not retry(lambda: call(path, 'isSecure').stdout.strip() == 'true'):
        raise RuntimeError('Pond lockscreen did not confirm the lock')


def call(path, method):
    return subprocess.run(['qs', '-p', str(path), 'ipc', 'call', 'lockscreen', method],
                          capture_output=True, text=True)


def retry(check):
    for _ in range(30):
        if check():
            return True
        time.sleep(0.1)
    return False


if __name__ == '__main__':
    run(sys.argv[1])
