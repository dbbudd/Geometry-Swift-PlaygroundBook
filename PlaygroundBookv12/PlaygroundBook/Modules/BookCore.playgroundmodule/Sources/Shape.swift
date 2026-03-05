import SpriteKit

@MainActor public struct ShapeSK {
    public let node = SKShapeNode()

    public init(pen: Pen) {
        node.path = pen.path.cgPath
        node.fillColor = pen.fillColor
        node.strokeColor = pen.penColor
        node.lineWidth = pen.lineWidth
    }
}
