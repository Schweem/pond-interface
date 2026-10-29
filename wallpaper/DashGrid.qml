import QtQuick
import QtQuick.Window

// A dashed grid drawn once at physical resolution so every line lands on a
// single device pixel, including at fractional scales.
Item {
  id: root
  property color color: "transparent"
  property real spacing: 40
  property real dash: 4
  readonly property real pixelRatio: Window.window?.devicePixelRatio ?? 1

  Canvas {
    id: canvas
    width: Math.ceil(root.width * root.pixelRatio)
    height: Math.ceil(root.height * root.pixelRatio)
    scale: 1 / root.pixelRatio
    transformOrigin: Item.TopLeft
    visible: root.color.a > 0

    onPaint: {
      const ctx = getContext("2d");
      ctx.reset();
      ctx.fillStyle = root.color;
      const step = root.spacing * root.pixelRatio;
      const dash = Math.max(1, Math.round(root.dash * root.pixelRatio));
      const line = Math.max(1, Math.floor(root.pixelRatio));
      for (let x = Math.round(step); x < width; x = Math.round(x + step))
        for (let y = 0; y < height; y += dash * 2) ctx.fillRect(x, y, line, dash);
      for (let y = Math.round(step); y < height; y = Math.round(y + step))
        for (let x = 0; x < width; x += dash * 2) ctx.fillRect(x, y, dash, line);
    }
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()
  }
  onColorChanged: canvas.requestPaint()
  onSpacingChanged: canvas.requestPaint()
  onDashChanged: canvas.requestPaint()
}
