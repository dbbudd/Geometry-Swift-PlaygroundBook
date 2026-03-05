import UIKit

public final class GridPaperView: UIView {
    public var minorGridSpacing: CGFloat = 10 {
        didSet {
            minorGridSpacing = max(1, minorGridSpacing)
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    public var majorGridStep: Int = 5 {
        didSet {
            majorGridStep = max(1, majorGridStep)
            setNeedsDisplay()
            setNeedsLayout()
        }
    }

    public var axisLineWidth: CGFloat = 2.0 {
        didSet { setNeedsDisplay() }
    }

    public var gridLineWidth: CGFloat = 0.6 {
        didSet { setNeedsDisplay() }
    }

    public var minorGridColor: UIColor = UIColor(red: 0.87, green: 0.90, blue: 0.95, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }

    public var majorGridColor: UIColor = UIColor(red: 0.74, green: 0.79, blue: 0.87, alpha: 1.0) {
        didSet { setNeedsDisplay() }
    }

    public var axisColor: UIColor = UIColor(red: 0.14, green: 0.20, blue: 0.29, alpha: 1.0) {
        didSet {
            setNeedsDisplay()
            updateAxisLabelStyles()
        }
    }

    private let xAxisLabel = UILabel()
    private let yAxisLabel = UILabel()
    private let tickLabelsContainer = UIView()
    private let drawnShapesLayer = CALayer()
    private var pens: [Pen] = []
    private let axisLabelOffset: CGFloat = 24
    private let tickLabelOffset: CGFloat = 22

    public override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    public override var bounds: CGRect {
        didSet {
            if oldValue.size != bounds.size {
                setNeedsDisplay()
                setNeedsLayout()
            }
        }
    }

    public override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext(), rect.width > 0, rect.height > 0 else { return }

        context.setFillColor(UIColor.white.cgColor)
        context.fill(rect)

        drawGrid(in: rect, context: context)
        drawAxes(in: rect, context: context)
    }

    public override func layoutSubviews() {
        super.layoutSubviews()

        tickLabelsContainer.frame = bounds
        drawnShapesLayer.frame = bounds
        redrawShapes()

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        xAxisLabel.sizeToFit()
        yAxisLabel.sizeToFit()

        xAxisLabel.frame.origin = CGPoint(
            x: bounds.maxX - xAxisLabel.bounds.width - 12,
            y: center.y + axisLabelOffset
        )

        yAxisLabel.frame.origin = CGPoint(
            x: center.x + axisLabelOffset,
            y: 8
        )

        rebuildTickLabels()
    }

    public func add(pen: Pen) {
        pens.append(pen)
        render(pen: pen)
    }

    private func render(pen: Pen) {
        let shapeLayer = CAShapeLayer()
        let transformedPath = UIBezierPath(cgPath: pen.path.cgPath)
        transformedPath.apply(cartesianToViewTransform())
        shapeLayer.path = transformedPath.cgPath
        shapeLayer.fillColor = pen.fillColor.cgColor
        shapeLayer.strokeColor = pen.penColor.cgColor
        shapeLayer.lineWidth = pen.lineWidth
        shapeLayer.lineJoin = .round
        shapeLayer.lineCap = .round

        CATransaction.begin()
        CATransaction.setDisableActions(true)
        drawnShapesLayer.addSublayer(shapeLayer)
        CATransaction.commit()
    }

    private func commonInit() {
        isOpaque = true
        backgroundColor = .white
        contentMode = .redraw

        layer.addSublayer(drawnShapesLayer)

        tickLabelsContainer.isUserInteractionEnabled = false
        addSubview(tickLabelsContainer)

        xAxisLabel.text = "x"
        yAxisLabel.text = "y"
        updateAxisLabelStyles()

        addSubview(xAxisLabel)
        addSubview(yAxisLabel)
    }

    private func cartesianToViewTransform() -> CGAffineTransform {
        CGAffineTransform(
            a: 1, b: 0,
            c: 0, d: -1,
            tx: bounds.midX,
            ty: bounds.midY
        )
    }

    private func redrawShapes() {
        drawnShapesLayer.sublayers?.forEach { $0.removeFromSuperlayer() }
        pens.forEach { render(pen: $0) }
    }

    private func updateAxisLabelStyles() {
        let axisFont = UIFont.systemFont(ofSize: 14, weight: .semibold)
        xAxisLabel.font = axisFont
        yAxisLabel.font = axisFont
        xAxisLabel.textColor = axisColor
        yAxisLabel.textColor = axisColor
    }

    private func drawGrid(in rect: CGRect, context: CGContext) {
        let center = CGPoint(x: rect.midX, y: rect.midY)

        context.saveGState()
        context.setLineWidth(gridLineWidth)

        var x = center.x
        var index = 0
        while x <= rect.maxX {
            drawVerticalLine(x: x, in: rect, index: index, context: context)
            x += minorGridSpacing
            index += 1
        }

        x = center.x - minorGridSpacing
        index = 1
        while x >= rect.minX {
            drawVerticalLine(x: x, in: rect, index: index, context: context)
            x -= minorGridSpacing
            index += 1
        }

        var y = center.y
        index = 0
        while y <= rect.maxY {
            drawHorizontalLine(y: y, in: rect, index: index, context: context)
            y += minorGridSpacing
            index += 1
        }

        y = center.y - minorGridSpacing
        index = 1
        while y >= rect.minY {
            drawHorizontalLine(y: y, in: rect, index: index, context: context)
            y -= minorGridSpacing
            index += 1
        }

        context.restoreGState()
    }

    private func drawAxes(in rect: CGRect, context: CGContext) {
        context.saveGState()
        context.setStrokeColor(axisColor.cgColor)
        context.setLineWidth(axisLineWidth)

        context.move(to: CGPoint(x: rect.minX, y: rect.midY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.midY))

        context.move(to: CGPoint(x: rect.midX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))

        context.strokePath()
        context.restoreGState()
    }

    private func drawVerticalLine(x: CGFloat, in rect: CGRect, index: Int, context: CGContext) {
        let isMajor = index % majorGridStep == 0
        context.setStrokeColor((isMajor ? majorGridColor : minorGridColor).cgColor)

        context.move(to: CGPoint(x: x, y: rect.minY))
        context.addLine(to: CGPoint(x: x, y: rect.maxY))
        context.strokePath()
    }

    private func drawHorizontalLine(y: CGFloat, in rect: CGRect, index: Int, context: CGContext) {
        let isMajor = index % majorGridStep == 0
        context.setStrokeColor((isMajor ? majorGridColor : minorGridColor).cgColor)

        context.move(to: CGPoint(x: rect.minX, y: y))
        context.addLine(to: CGPoint(x: rect.maxX, y: y))
        context.strokePath()
    }

    private func rebuildTickLabels() {
        tickLabelsContainer.subviews.forEach { $0.removeFromSuperview() }

        let tickSpacing = minorGridSpacing * CGFloat(majorGridStep)
        guard tickSpacing > 0 else { return }

        let center = CGPoint(x: bounds.midX, y: bounds.midY)
        let textColor = axisColor.withAlphaComponent(0.8)
        let font = UIFont.systemFont(ofSize: 10, weight: .medium)

        var value = 1
        var x = center.x + tickSpacing
        while x < bounds.maxX - 8 {
            addTickLabel(text: "\(value)", center: CGPoint(x: x, y: center.y + tickLabelOffset), font: font, color: textColor)
            addTickLabel(text: "-\(value)", center: CGPoint(x: center.x - (x - center.x), y: center.y + tickLabelOffset), font: font, color: textColor)
            x += tickSpacing
            value += 1
        }

        value = 1
        var y = center.y - tickSpacing
        while y > bounds.minY + 8 {
            addTickLabel(text: "\(value)", center: CGPoint(x: center.x + tickLabelOffset, y: y), font: font, color: textColor)
            addTickLabel(text: "-\(value)", center: CGPoint(x: center.x + tickLabelOffset, y: center.y + (center.y - y)), font: font, color: textColor)
            y -= tickSpacing
            value += 1
        }
    }

    private func addTickLabel(text: String, center: CGPoint, font: UIFont, color: UIColor) {
        let label = UILabel()
        label.text = text
        label.font = font
        label.textColor = color
        label.sizeToFit()
        label.center = center
        tickLabelsContainer.addSubview(label)
    }
}
