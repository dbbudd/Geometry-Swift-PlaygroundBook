import UIKit
import SwiftUI
import PlaygroundSupport

private enum LiveViewMessageKey {
    static let type = "type"
    static let steps = "steps"
    static let lineWidth = "lineWidth"
    static let zPosition = "zPosition"
    static let penColor = "penColor"
    static let fillColor = "fillColor"

    static let stepInstruction = "instruction"
    static let stepFirst = "first"
    static let stepSecond = "second"

    static let colorRed = "r"
    static let colorGreen = "g"
    static let colorBlue = "b"
    static let colorAlpha = "a"

    static let addShape = "addShape"
    static let setShapes = "setShapes"
    static let shapes = "shapes"
    static let registerInput = "registerInput"
    static let inputID = "inputID"
    static let inputTitle = "inputTitle"
    static let inputKind = "inputKind"
    static let inputText = "inputText"
    static let inputDecimal = "inputDecimal"
    static let inputNumber = "inputNumber"
    static let setViewOptions = "setViewOptions"
    static let viewShowGrid = "viewShowGrid"
    static let viewShowAxes = "viewShowAxes"
    static let viewShowLabels = "viewShowLabels"
    static let viewShowControls = "viewShowControls"
    static let addMeasurements = "addMeasurements"
    static let setMeasurements = "setMeasurements"
    static let measurements = "measurements"
    static let measurementID = "measurementID"
    static let measurementText = "measurementText"
    static let measurementX = "measurementX"
    static let measurementY = "measurementY"
    static let measurementFontSize = "measurementFontSize"
    static let measurementColor = "measurementColor"
    static let measurementZPosition = "measurementZPosition"
}

@objc(BookCore_LiveViewController)
public class LiveViewController: UIViewController, PlaygroundLiveViewMessageHandler, PlaygroundLiveViewSafeAreaContainer {
    private let planeModel = CartesianPlaneModel()

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        let hostingController = UIHostingController(rootView: CartesianPlaneView(model: planeModel))
        addChild(hostingController)

        guard let hostedView = hostingController.view else { return }
        hostedView.translatesAutoresizingMaskIntoConstraints = false
        hostedView.backgroundColor = .clear
        view.addSubview(hostedView)

        NSLayoutConstraint.activate([
            hostedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            hostedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            hostedView.topAnchor.constraint(equalTo: view.topAnchor),
            hostedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        hostingController.didMove(toParent: self)

        LiveViewMessageRouter.shared.handler = { [weak self] message in
            self?.receive(message)
        }
    }

    public func receive(_ message: PlaygroundValue) {
        guard
            case .dictionary(let dictionary) = message,
            case .string(let type)? = dictionary[LiveViewMessageKey.type]
        else {
            return
        }

        switch type {
        case LiveViewMessageKey.addShape:
            let pens = decodePens(from: dictionary)
            pens.forEach { planeModel.add(pen: $0) }

        case LiveViewMessageKey.setShapes:
            let pens = decodePens(from: dictionary)
            planeModel.setPens(pens)

        case LiveViewMessageKey.registerInput:
            guard let input = decodeInput(from: dictionary) else { return }
            planeModel.registerInput(input)

        case LiveViewMessageKey.addMeasurements:
            let measurements = decodeMeasurements(from: dictionary)
            measurements.forEach { planeModel.addMeasurement($0) }

        case LiveViewMessageKey.setMeasurements:
            let measurements = decodeMeasurements(from: dictionary)
            planeModel.setMeasurements(measurements)

        case LiveViewMessageKey.setViewOptions:
            let showGrid = decodeBoolean(from: dictionary[LiveViewMessageKey.viewShowGrid]) ?? true
            let showAxes = decodeBoolean(from: dictionary[LiveViewMessageKey.viewShowAxes]) ?? true
            let showLabels = decodeBoolean(from: dictionary[LiveViewMessageKey.viewShowLabels]) ?? true
            let showControls = decodeBoolean(from: dictionary[LiveViewMessageKey.viewShowControls]) ?? true
            planeModel.setViewOptions(
                isGridVisible: showGrid,
                isAxesVisible: showAxes,
                isLabelsVisible: showLabels,
                isControlsVisible: showControls
            )

        default:
            break
        }
    }

    private func decodeMeasurements(from dictionary: [String: PlaygroundValue]) -> [PlaneMeasurementOverlay] {
        guard case .array(let measurementValues)? = dictionary[LiveViewMessageKey.measurements] else { return [] }
        return measurementValues.compactMap(decodeMeasurement(from:))
    }

    private func decodeBoolean(from value: PlaygroundValue?) -> Bool? {
        guard let value else { return nil }
        if case .boolean(let boolValue) = value { return boolValue }
        if case .integer(let intValue) = value { return intValue != 0 }
        return nil
    }

    private func decodeMeasurement(from value: PlaygroundValue) -> PlaneMeasurementOverlay? {
        guard case .dictionary(let dictionary) = value else { return nil }
        guard
            case .string(let id)? = dictionary[LiveViewMessageKey.measurementID],
            case .string(let text)? = dictionary[LiveViewMessageKey.measurementText],
            case .floatingPoint(let x)? = dictionary[LiveViewMessageKey.measurementX],
            case .floatingPoint(let y)? = dictionary[LiveViewMessageKey.measurementY],
            case .floatingPoint(let fontSize)? = dictionary[LiveViewMessageKey.measurementFontSize],
            let colorValue = dictionary[LiveViewMessageKey.measurementColor],
            let color = decodeColor(from: colorValue),
            case .integer(let zPosition)? = dictionary[LiveViewMessageKey.measurementZPosition]
        else {
            return nil
        }

        return PlaneMeasurementOverlay(
            id: id,
            text: text,
            x: x,
            y: y,
            color: color,
            fontSize: CGFloat(fontSize),
            zPosition: zPosition
        )
    }

    public func addShapeForDebug(_ pen: Pen) {
        planeModel.add(pen: pen)
    }


    public func setShapesForDebug(_ pens: [Pen]) {
        planeModel.setPens(pens)
    }

    private func decodePens(from dictionary: [String: PlaygroundValue]) -> [Pen] {
        if case .array(let shapeValues)? = dictionary[LiveViewMessageKey.shapes] {
            return shapeValues.compactMap(decodePen(from:))
        }

        if let pen = decodePen(from: dictionary) {
            return [pen]
        }

        return []
    }

    private func decodePen(from value: PlaygroundValue) -> Pen? {
        guard case .dictionary(let dictionary) = value else { return nil }
        return decodePen(from: dictionary)
    }

    private func decodeInput(from dictionary: [String: PlaygroundValue]) -> PlaneInput? {
        guard
            case .string(let id)? = dictionary[LiveViewMessageKey.inputID],
            case .string(let title)? = dictionary[LiveViewMessageKey.inputTitle],
            case .string(let kindRawValue)? = dictionary[LiveViewMessageKey.inputKind],
            let kind = PlaneInputKind(rawValue: kindRawValue)
        else {
            return nil
        }

        var textValue = ""
        var decimalValue: Double = 0
        var numberValue: Int = 0

        if case .string(let value)? = dictionary[LiveViewMessageKey.inputText] {
            textValue = value
        }

        if case .floatingPoint(let value)? = dictionary[LiveViewMessageKey.inputDecimal] {
            decimalValue = value
        }

        if case .integer(let value)? = dictionary[LiveViewMessageKey.inputNumber] {
            numberValue = value
        }

        return PlaneInput(
            id: id,
            title: title,
            kind: kind,
            textValue: textValue,
            decimalValue: decimalValue,
            numberValue: numberValue
        )
    }

    private func decodePen(from dictionary: [String: PlaygroundValue]) -> Pen? {
        guard
            case .array(let stepValues)? = dictionary[LiveViewMessageKey.steps],
            case .floatingPoint(let lineWidthDouble)? = dictionary[LiveViewMessageKey.lineWidth],
            let penColorValue = dictionary[LiveViewMessageKey.penColor],
            let fillColorValue = dictionary[LiveViewMessageKey.fillColor],
            let penColor = decodeColor(from: penColorValue),
            let fillColor = decodeColor(from: fillColorValue)
        else {
            return nil
        }

        var pen = Pen()
        pen.penColor = penColor
        pen.fillColor = fillColor
        pen.lineWidth = CGFloat(lineWidthDouble)
        if case .integer(let zPosition)? = dictionary[LiveViewMessageKey.zPosition] {
            pen.zPosition = zPosition
        }

        for stepValue in stepValues {
            guard case .dictionary(let stepDictionary) = stepValue else { continue }

            guard
                case .string(let instructionRawValue)? = stepDictionary[LiveViewMessageKey.stepInstruction],
                let instruction = PenInstruction(rawValue: instructionRawValue),
                case .floatingPoint(let first)? = stepDictionary[LiveViewMessageKey.stepFirst]
            else {
                continue
            }

            let second: Double?
            if case .floatingPoint(let value)? = stepDictionary[LiveViewMessageKey.stepSecond] {
                second = value
            } else {
                second = nil
            }

            apply(step: instruction, first: first, second: second, to: &pen)
        }

        return pen
    }

    private func decodeColor(from value: PlaygroundValue) -> UIColor? {
        guard
            case .dictionary(let dictionary) = value,
            case .floatingPoint(let red)? = dictionary[LiveViewMessageKey.colorRed],
            case .floatingPoint(let green)? = dictionary[LiveViewMessageKey.colorGreen],
            case .floatingPoint(let blue)? = dictionary[LiveViewMessageKey.colorBlue],
            case .floatingPoint(let alpha)? = dictionary[LiveViewMessageKey.colorAlpha]
        else {
            return nil
        }

        return UIColor(
            red: CGFloat(red),
            green: CGFloat(green),
            blue: CGFloat(blue),
            alpha: CGFloat(alpha)
        )
    }

    private func apply(step: PenInstruction, first: Double, second: Double?, to pen: inout Pen) {
        switch step {
        case .addLine:
            pen.addLine(distance: first)
        case .move:
            pen.move(distance: first)
        case .goto:
            pen.goto(x: first, y: second ?? 0)
        case .drawTo:
            pen.drawTo(dx: first, dy: second ?? 0)
        case .turn:
            pen.turn(degrees: first)
        case .drawCircle:
            pen.drawCircle(radius: CGFloat(first))
        case .addArc:
            pen.addArc(radius: first, angle: second ?? 0)
        }
    }
}
