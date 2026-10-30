import QtQuick
import QtQuick.Shapes

// Draws one of Glyphs.js's icons at this item's size, in theme colors.
Item {
    id: root
    required property var glyph
    property color color: "black"
    // The color behind the glyph, showing through its cut marks.
    property color cutColor: "transparent"

    Shape {
        width: root.glyph.size
        height: root.glyph.size
        scale: root.width / root.glyph.size
        transformOrigin: Item.TopLeft
        preferredRendererType: Shape.CurveRenderer

        ShapePath {
            fillColor: root.color
            strokeColor: root.glyph.outline ? root.color : "transparent"
            strokeWidth: root.glyph.outline ?? -1
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: root.glyph.fill ?? "" }
        }
        ShapePath {
            fillColor: "transparent"
            strokeColor: root.color
            strokeWidth: root.glyph.stroke ? root.glyph.strokeWidth : -1
            capStyle: root.glyph.round ? ShapePath.RoundCap : ShapePath.FlatCap
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: root.glyph.stroke ?? "" }
        }
        ShapePath {
            fillColor: "transparent"
            strokeColor: root.cutColor
            strokeWidth: root.glyph.cut ? 2 : -1
            capStyle: ShapePath.RoundCap
            joinStyle: ShapePath.RoundJoin
            PathSvg { path: root.glyph.cut ?? "" }
        }
    }
}
