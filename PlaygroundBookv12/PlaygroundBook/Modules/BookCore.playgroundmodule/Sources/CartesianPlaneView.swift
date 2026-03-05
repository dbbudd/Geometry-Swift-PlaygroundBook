import SwiftUI
import UIKit

public enum PlaneInputKind: String {
    case text
    case decimal
    case number
}

public struct PlaneInput: Identifiable, Equatable {
    public let id: String
    public let title: String
    public let kind: PlaneInputKind

    public var textValue: String
    public var decimalValue: Double
    public var numberValue: Int
}

public struct PlaneShape: Identifiable {
    public let id = UUID()
    public let pen: Pen
    public let zPosition: Int
}

public struct PlaneMeasurementOverlay: Identifiable {
    public let id: String
    public let text: String
    public let x: Double
    public let y: Double
    public let color: UIColor
    public let fontSize: CGFloat
    public let zPosition: Int
}

@MainActor
public final class CartesianPlaneModel: ObservableObject {
    @Published public private(set) var shapes: [PlaneShape] = []
    @Published public private(set) var inputs: [PlaneInput] = []
    @Published public private(set) var measurements: [PlaneMeasurementOverlay] = []
    @Published public private(set) var isGridVisible: Bool = true
    @Published public private(set) var isAxesVisible: Bool = true
    @Published public private(set) var isLabelsVisible: Bool = true
    @Published public private(set) var isControlsVisible: Bool = true
    @Published private(set) var renderRevision: Int = 0
    private var nextShapeZPosition: Int = 0

    public var minorGridSpacing: CGFloat = 10
    public var majorGridStep: Int = 5

    public init() {}

    public func add(pen: Pen) {
        let zPosition = pen.zPosition ?? nextShapeZPosition
        shapes.append(PlaneShape(pen: pen, zPosition: zPosition))
        nextShapeZPosition = max(nextShapeZPosition, zPosition + 1)
        renderRevision += 1
    }

    public func clear() {
        shapes.removeAll()
        measurements.removeAll()
        nextShapeZPosition = 0
        renderRevision += 1
    }

    public func setPens(_ newPens: [Pen]) {
        shapes = newPens.enumerated().map { index, pen in
            PlaneShape(pen: pen, zPosition: pen.zPosition ?? index)
        }
        let maxZ = shapes.map(\.zPosition).max() ?? -1
        nextShapeZPosition = maxZ + 1
        renderRevision += 1
    }

    public func addMeasurement(_ overlay: PlaneMeasurementOverlay) {
        measurements.append(overlay)
        renderRevision += 1
    }

    public func setMeasurements(_ overlays: [PlaneMeasurementOverlay]) {
        measurements = overlays
        renderRevision += 1
    }

    public func setViewOptions(
        isGridVisible: Bool,
        isAxesVisible: Bool,
        isLabelsVisible: Bool,
        isControlsVisible: Bool
    ) {
        guard
            self.isGridVisible != isGridVisible ||
            self.isAxesVisible != isAxesVisible ||
            self.isLabelsVisible != isLabelsVisible ||
            self.isControlsVisible != isControlsVisible
        else {
            return
        }
        self.isGridVisible = isGridVisible
        self.isAxesVisible = isAxesVisible
        self.isLabelsVisible = isLabelsVisible
        self.isControlsVisible = isControlsVisible
        renderRevision += 1
    }

    public func setGridVisible(_ visible: Bool) {
        guard isGridVisible != visible else { return }
        isGridVisible = visible
        renderRevision += 1
    }

    public func setAxesVisible(_ visible: Bool) {
        guard isAxesVisible != visible else { return }
        isAxesVisible = visible
        renderRevision += 1
    }

    public func setLabelsVisible(_ visible: Bool) {
        guard isLabelsVisible != visible else { return }
        isLabelsVisible = visible
        renderRevision += 1
    }

    public func registerInput(_ input: PlaneInput) {
        if let index = inputs.firstIndex(where: { $0.id == input.id }) {
            inputs[index] = input
        } else {
            inputs.append(input)
        }

        LiveViewInputStore.shared.upsert(input)
        renderRevision += 1
    }

    public func updateDecimalInput(id: String, value: Double) {
        guard let index = inputs.firstIndex(where: { $0.id == id }) else { return }
        inputs[index].decimalValue = value
        LiveViewInputStore.shared.upsert(inputs[index])
        renderRevision += 1
    }

    public func updateNumberInput(id: String, value: Int) {
        guard let index = inputs.firstIndex(where: { $0.id == id }) else { return }
        inputs[index].numberValue = value
        LiveViewInputStore.shared.upsert(inputs[index])
        renderRevision += 1
    }

    public func updateTextInput(id: String, value: String) {
        guard let index = inputs.firstIndex(where: { $0.id == id }) else { return }
        inputs[index].textValue = value
        LiveViewInputStore.shared.upsert(inputs[index])
        renderRevision += 1
    }

    public func decimalValue(for id: String) -> Double {
        inputs.first(where: { $0.id == id })?.decimalValue ?? 0
    }

    public func numberValue(for id: String) -> Int {
        inputs.first(where: { $0.id == id })?.numberValue ?? 0
    }

    public func textValue(for id: String) -> String {
        inputs.first(where: { $0.id == id })?.textValue ?? ""
    }
}

public struct CartesianPlaneView: View {
    @ObservedObject private var model: CartesianPlaneModel
    @State private var isInputPanelMinimized = false
    @State private var isPreferencesPanelVisible = false

    private let minorGridColor = Color(red: 0.87, green: 0.90, blue: 0.95)
    private let majorGridColor = Color(red: 0.74, green: 0.79, blue: 0.87)
    private let axisColor = Color(red: 0.14, green: 0.20, blue: 0.29)
    private let inputControlWidth: CGFloat = 200

    public init(model: CartesianPlaneModel) {
        self.model = model
    }

    public var body: some View {
        GeometryReader { proxy in
            let size = proxy.size
            let center = CGPoint(x: size.width / 2, y: size.height / 2)
            let _ = model.renderRevision

            ZStack(alignment: .topTrailing) {
                Canvas { context, _ in
                    if model.isGridVisible {
                        drawGrid(in: &context, size: size, center: center)
                    }
                    if model.isAxesVisible {
                        drawAxes(in: &context, size: size, center: center)
                    }
                    drawPens(in: &context, center: center)
                }

                if model.isLabelsVisible {
                    axisLabels(center: center, size: size)
                    tickLabels(center: center, size: size)
                }
                measurementLabels(center: center)
                VStack(alignment: .trailing, spacing: 8) {
                    if model.isControlsVisible {
                        if isInputPanelMinimized {
                            minimizedButtons
                        } else {
                            inputPanel
                        }
                    } else {
                        preferencesButton
                    }

                    if isPreferencesPanelVisible {
                        preferencesPanel
                    }
                }
            }
            .background(.white)
        }
    }

    @ViewBuilder
    private func measurementLabels(center: CGPoint) -> some View {
        ForEach(model.measurements.sorted(by: { $0.zPosition < $1.zPosition })) { overlay in
            Text(overlay.text)
                .font(.system(size: overlay.fontSize, weight: .semibold))
                .foregroundStyle(Color(uiColor: overlay.color))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.white.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .position(x: center.x + overlay.x, y: center.y - overlay.y)
                .zIndex(Double(overlay.zPosition))
        }
    }

    @ViewBuilder
    private func axisLabels(center: CGPoint, size: CGSize) -> some View {
        Text("x-axis")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(axisColor)
            .position(x: size.width - 50, y: center.y - 20)

        Text("y-axis")
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(axisColor)
            .position(x: center.x + 24, y: 16)
    }

    @ViewBuilder
    private func tickLabels(center: CGPoint, size: CGSize) -> some View {
        let tickSpacing = model.minorGridSpacing * CGFloat(max(1, model.majorGridStep))
        let offset: CGFloat = 22

        ForEach(horizontalTickValues(size: size, center: center, tickSpacing: tickSpacing), id: \.self.value) { tick in
            Text(tick.label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(axisColor.opacity(0.8))
                .position(x: tick.x, y: center.y + offset)
        }

        ForEach(verticalTickValues(size: size, center: center, tickSpacing: tickSpacing), id: \.self.value) { tick in
            Text(tick.label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(axisColor.opacity(0.8))
                .position(x: center.x + offset, y: tick.y)
        }
    }

    private var inputPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.gray.opacity(0.8))
                Text("Controls")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.gray.opacity(0.9))

                Spacer(minLength: 4)

                Button {
                    isInputPanelMinimized = true
                } label: {
                    Image(systemName: "chevron.up")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.gray.opacity(0.8))
                }
                .buttonStyle(.plain)

                Button {
                    isPreferencesPanelVisible.toggle()
                } label: {
                    Image(systemName: "slider.horizontal.3")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Color.gray.opacity(0.8))
                }
                .buttonStyle(.plain)
            }
            .frame(width: inputControlWidth, alignment: .leading)
            .padding(.bottom, 2)

            ForEach(model.inputs) { input in
                inputRow(for: input)
            }
        }
        .padding(10)
        .background(Color.white.opacity(0.94))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(10)
        .padding(.top, 12)
        .padding(.trailing, 12)
    }

    private var minimizedButtons: some View {
        HStack(spacing: 8) {
            Button {
                isInputPanelMinimized = false
            } label: {
                Image(systemName: "gearshape.fill")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.white)
                    .padding(10)
                    .background(Color.black.opacity(0.6))
                    .clipShape(Circle())
            }
            .buttonStyle(.plain)

            preferencesButton
        }
        .padding(.top, 12)
        .padding(.trailing, 12)
    }

    private var preferencesButton: some View {
        Button {
            isPreferencesPanelVisible.toggle()
        } label: {
            Image(systemName: "slider.horizontal.3")
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(Color.white)
                .padding(10)
                .background(Color.black.opacity(0.6))
                .clipShape(Circle())
        }
        .buttonStyle(.plain)
    }

    private var preferencesPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.gray.opacity(0.8))
                Text("Preferences")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.gray.opacity(0.9))
                Spacer(minLength: 4)
            }
            .frame(width: inputControlWidth, alignment: .leading)
            .padding(.bottom, 2)

            Toggle("Show Grid", isOn: Binding(
                get: { model.isGridVisible },
                set: { model.setGridVisible($0) }
            ))
            Toggle("Show Axes", isOn: Binding(
                get: { model.isAxesVisible },
                set: { model.setAxesVisible($0) }
            ))
            Toggle("Show Labels", isOn: Binding(
                get: { model.isLabelsVisible },
                set: { model.setLabelsVisible($0) }
            ))
        }
        .font(.system(size: 13, weight: .semibold))
        .toggleStyle(.switch)
        .frame(width: inputControlWidth)
        .padding(10)
        .background(Color.white.opacity(0.94))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.gray.opacity(0.25), lineWidth: 1)
        )
        .cornerRadius(10)
        .padding(.trailing, 12)
    }

    @ViewBuilder
    private func inputRow(for input: PlaneInput) -> some View {
        switch input.kind {
        case .text:
            VStack(alignment: .leading, spacing: 4) {
                Text(input.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.black.opacity(0.75))

                TextField(
                    "",
                    text: Binding(
                        get: { model.textValue(for: input.id) },
                        set: { model.updateTextInput(id: input.id, value: $0) }
                    )
                )
                .textFieldStyle(.roundedBorder)
                .frame(width: inputControlWidth)
                .keyboardType(.default)
                .multilineTextAlignment(.center)
            }

        case .decimal:
            VStack(alignment: .leading, spacing: 4) {
                Text(input.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.black.opacity(0.75))

                HStack(spacing: 6) {
                    TextField(
                        "",
                        value: Binding(
                            get: { model.decimalValue(for: input.id) },
                            set: { model.updateDecimalInput(id: input.id, value: $0) }
                        ),
                        format: .number
                    )
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .keyboardType(.decimalPad)
                    .multilineTextAlignment(.center)

                    Stepper(
                        "",
                        value: Binding(
                            get: { model.decimalValue(for: input.id) },
                            set: { model.updateDecimalInput(id: input.id, value: $0) }
                        ),
                        in: -500...500,
                        step: 1.0
                    )
                    .labelsHidden()
                    .frame(width: 94)
                }
                .frame(width: inputControlWidth, alignment: .leading)
            }

        case .number:
            VStack(alignment: .leading, spacing: 4) {
                Text(input.title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Color.black.opacity(0.75))

                HStack(spacing: 6) {
                    TextField(
                        "",
                        value: Binding(
                            get: { model.numberValue(for: input.id) },
                            set: { model.updateNumberInput(id: input.id, value: $0) }
                        ),
                        format: .number
                    )
                    .textFieldStyle(.roundedBorder)
                    .frame(width: 100)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.center)

                    Stepper(
                        "",
                        value: Binding(
                            get: { model.numberValue(for: input.id) },
                            set: { model.updateNumberInput(id: input.id, value: $0) }
                        ),
                        in: -500...500,
                        step: 1
                    )
                    .labelsHidden()
                    .frame(width: 94)
                }
                .frame(width: inputControlWidth, alignment: .leading)
            }
        }
    }

    private func horizontalTickValues(size: CGSize, center: CGPoint, tickSpacing: CGFloat) -> [(value: Int, label: String, x: CGFloat)] {
        guard tickSpacing > 0 else { return [] }

        var ticks: [(Int, String, CGFloat)] = []
        var step = 1
        var x = center.x + tickSpacing

        while x < size.width - 8 {
            let pixelValue = Int((CGFloat(step) * tickSpacing).rounded())
            ticks.append((pixelValue, "\(pixelValue)", x))
            let negativeX = center.x - (x - center.x)
            if negativeX > 8 {
                ticks.append((-pixelValue, "-\(pixelValue)", negativeX))
            }
            step += 1
            x += tickSpacing
        }

        return ticks
    }

    private func verticalTickValues(size: CGSize, center: CGPoint, tickSpacing: CGFloat) -> [(value: Int, label: String, y: CGFloat)] {
        guard tickSpacing > 0 else { return [] }

        var ticks: [(Int, String, CGFloat)] = []
        var step = 1
        var y = center.y - tickSpacing

        while y > 8 {
            let pixelValue = Int((CGFloat(step) * tickSpacing).rounded())
            ticks.append((pixelValue, "\(pixelValue)", y))
            let negativeY = center.y + (center.y - y)
            if negativeY < size.height - 8 {
                ticks.append((-pixelValue, "-\(pixelValue)", negativeY))
            }
            step += 1
            y -= tickSpacing
        }

        return ticks
    }

    private func drawGrid(in context: inout GraphicsContext, size: CGSize, center: CGPoint) {
        let spacing = max(1, model.minorGridSpacing)
        let majorStep = max(1, model.majorGridStep)

        var x = center.x
        var index = 0
        while x <= size.width {
            let path = Path { path in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            let isMajor = index % majorStep == 0
            context.stroke(path, with: .color(isMajor ? majorGridColor : minorGridColor), lineWidth: 0.6)
            x += spacing
            index += 1
        }

        x = center.x - spacing
        index = 1
        while x >= 0 {
            let path = Path { path in
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
            }
            let isMajor = index % majorStep == 0
            context.stroke(path, with: .color(isMajor ? majorGridColor : minorGridColor), lineWidth: 0.6)
            x -= spacing
            index += 1
        }

        var y = center.y
        index = 0
        while y <= size.height {
            let path = Path { path in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
            let isMajor = index % majorStep == 0
            context.stroke(path, with: .color(isMajor ? majorGridColor : minorGridColor), lineWidth: 0.6)
            y += spacing
            index += 1
        }

        y = center.y - spacing
        index = 1
        while y >= 0 {
            let path = Path { path in
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
            }
            let isMajor = index % majorStep == 0
            context.stroke(path, with: .color(isMajor ? majorGridColor : minorGridColor), lineWidth: 0.6)
            y -= spacing
            index += 1
        }
    }

    private func drawAxes(in context: inout GraphicsContext, size: CGSize, center: CGPoint) {
        let horizontal = Path { path in
            path.move(to: CGPoint(x: 0, y: center.y))
            path.addLine(to: CGPoint(x: size.width, y: center.y))
        }

        let vertical = Path { path in
            path.move(to: CGPoint(x: center.x, y: 0))
            path.addLine(to: CGPoint(x: center.x, y: size.height))
        }

        context.stroke(horizontal, with: .color(axisColor), lineWidth: 2.0)
        context.stroke(vertical, with: .color(axisColor), lineWidth: 2.0)
    }

    private func drawPens(in context: inout GraphicsContext, center: CGPoint) {
        let transform = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: center.x, ty: center.y)

        for shape in model.shapes.sorted(by: { $0.zPosition < $1.zPosition }) {
            let pen = shape.pen
            let transformedPath = Path(pen.path.cgPath).applying(transform)

            if pen.fillColor.cgColor.alpha > 0 {
                context.fill(transformedPath, with: .color(Color(uiColor: pen.fillColor)))
            }

            context.stroke(
                transformedPath,
                with: .color(Color(uiColor: pen.penColor)),
                style: StrokeStyle(lineWidth: pen.lineWidth, lineCap: .round, lineJoin: .round)
            )
        }
    }
}
