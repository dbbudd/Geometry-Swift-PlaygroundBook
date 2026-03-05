import UIKit

public enum PenInstruction: String {
    case addLine
    case move
    case goto
    case drawTo
    case turn
    case drawCircle
    case addArc
}

public struct PenStep {
    public let instruction: PenInstruction
    public let first: Double
    public let second: Double?

    public init(instruction: PenInstruction, first: Double, second: Double? = nil) {
        self.instruction = instruction
        self.first = first
        self.second = second
    }
}

public struct Pen {
    public var penColor: UIColor = .blue
    public var fillColor: UIColor = .clear
    public var lineWidth: CGFloat = 3.0
    public var zPosition: Int? = nil

    public private(set) var currentHeading: Double = 0.0
    public private(set) var steps: [PenStep] = []

    public init() {}

    public var path: UIBezierPath {
        let builtPath = UIBezierPath()
        var heading: Double = 0
        builtPath.move(to: .zero)

        for step in steps {
            switch step.instruction {
            case .addLine:
                let distance = step.first
                let headingInRadians = heading * (.pi / 180)
                let dx = distance * cos(headingInRadians)
                let dy = distance * sin(headingInRadians)
                let current = builtPath.currentPoint
                builtPath.addLine(to: CGPoint(x: Double(current.x) + dx, y: Double(current.y) + dy))

            case .move:
                let distance = step.first
                let headingInRadians = heading * (.pi / 180)
                let dx = distance * cos(headingInRadians)
                let dy = distance * sin(headingInRadians)
                let current = builtPath.currentPoint
                builtPath.move(to: CGPoint(x: Double(current.x) + dx, y: Double(current.y) + dy))

            case .goto:
                let x = step.first
                let y = step.second ?? 0
                builtPath.move(to: CGPoint(x: x, y: y))

            case .drawTo:
                let dx = step.first
                let dy = step.second ?? 0
                let current = builtPath.currentPoint
                builtPath.addLine(to: CGPoint(x: Double(current.x) + dx, y: Double(current.y) + dy))

            case .turn:
                heading += step.first

            case .drawCircle:
                builtPath.addArc(
                    withCenter: builtPath.currentPoint,
                    radius: CGFloat(step.first),
                    startAngle: 0,
                    endAngle: CGFloat(Double.pi * 2),
                    clockwise: true
                )

            case .addArc:
                let radius = step.first
                let angle = step.second ?? 0
                let currentX = Double(builtPath.currentPoint.x)
                let currentY = Double(builtPath.currentPoint.y)

                if angle < 0 {
                    let toCenterInRadians = (90 - heading) * (.pi / 180)
                    let dx = radius * cos(toCenterInRadians)
                    let dy = -radius * sin(toCenterInRadians)
                    let centerX = currentX + dx
                    let centerY = currentY + dy
                    let startAngle = (90 + heading) * (.pi / 180)
                    let endAngle = (90 + heading + angle) * (.pi / 180)
                    heading += angle

                    builtPath.addArc(
                        withCenter: CGPoint(x: centerX, y: centerY),
                        radius: CGFloat(radius),
                        startAngle: CGFloat(startAngle),
                        endAngle: CGFloat(endAngle),
                        clockwise: false
                    )
                } else {
                    let toCenterInRadians = (90 + heading) * (.pi / 180)
                    let dx = radius * cos(toCenterInRadians)
                    let dy = radius * sin(toCenterInRadians)
                    let centerX = currentX + dx
                    let centerY = currentY + dy
                    let startAngle = (-90 + heading) * (.pi / 180)
                    let endAngle = (-90 + heading + angle) * (.pi / 180)
                    heading += angle

                    builtPath.addArc(
                        withCenter: CGPoint(x: centerX, y: centerY),
                        radius: CGFloat(radius),
                        startAngle: CGFloat(startAngle),
                        endAngle: CGFloat(endAngle),
                        clockwise: true
                    )
                }
            }
        }

        return builtPath
    }

    public func currentPosition() -> CGPoint {
        path.currentPoint
    }

    public mutating func addLine(distance: Double) {
        steps.append(PenStep(instruction: .addLine, first: distance))
    }

    public mutating func move(distance: Double) {
        steps.append(PenStep(instruction: .move, first: distance))
    }

    public mutating func goto(x: Double, y: Double) {
        steps.append(PenStep(instruction: .goto, first: x, second: y))
    }

    public mutating func goto(dx: Double, dy: Double) {
        let current = currentPosition()
        goto(x: Double(current.x) + dx, y: Double(current.y) + dy)
    }

    public mutating func drawTo(dx: Double, dy: Double) {
        steps.append(PenStep(instruction: .drawTo, first: dx, second: dy))
    }

    public mutating func turn(degrees: Double) {
        currentHeading += degrees
        steps.append(PenStep(instruction: .turn, first: degrees))
    }

    public mutating func drawCircle(radius: CGFloat) {
        steps.append(PenStep(instruction: .drawCircle, first: Double(radius)))
    }

    public mutating func addArc(radius: Double, angle: Double) {
        currentHeading += angle
        steps.append(PenStep(instruction: .addArc, first: radius, second: angle))
    }
}
