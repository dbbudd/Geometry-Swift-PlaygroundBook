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

public struct PlaneDraggablePoint: Identifiable {
    public let id: String
    public let x: Double
    public let y: Double
    public let radius: Double
    public let color: UIColor
    public let zPosition: Int
    public let isEnabled: Bool
}

public struct PlaneTraceFrame {
    public let pens: [Pen]
    public let measurements: [PlaneMeasurementOverlay]
    public let draggablePoints: [PlaneDraggablePoint]
}

@MainActor
public final class CartesianPlaneModel: ObservableObject {
    @Published public private(set) var shapes: [PlaneShape] = []
    @Published public private(set) var inputs: [PlaneInput] = []
    @Published public private(set) var measurements: [PlaneMeasurementOverlay] = []
    @Published public private(set) var draggablePoints: [PlaneDraggablePoint] = []
    @Published public private(set) var isGridVisible: Bool = true
    @Published public private(set) var isAxesVisible: Bool = true
    @Published public private(set) var isLabelsVisible: Bool = true
    @Published public private(set) var isControlsVisible: Bool = true
    @Published public private(set) var isHandlesVisible: Bool = true
    @Published public private(set) var isHandlesLocked: Bool = false
    @Published public private(set) var handleRadius: Double = 8
    @Published public private(set) var handleColor: UIColor = .systemBlue
    @Published public private(set) var handleSnapMode: String = "none"
    @Published public private(set) var handleSnapGridSpacing: Double = 10
    @Published public private(set) var isTraceControlsVisible: Bool = false
    @Published public private(set) var isTraceCaptureEnabled: Bool = false
    @Published public private(set) var traceCaptureOnlyOnChange: Bool = true
    @Published public private(set) var tracePlaybackSpeed: Double = 1.0
    @Published public private(set) var tracePlaybackIndex: Int = 0
    @Published public private(set) var isTracePlaying: Bool = false
    @Published public private(set) var traceFrameCount: Int = 0
    @Published private(set) var renderRevision: Int = 0
    private var nextShapeZPosition: Int = 0
    private var traceFrames: [PlaneTraceFrame] = []
    private var traceTimer: Timer?
    private var isApplyingTraceFrame = false
    private let maxTraceFrames = 600
    private var lastTraceSnapshotKey: String?

    public var minorGridSpacing: CGFloat = 10
    public var majorGridStep: Int = 5

    public init() {}

    public func add(pen: Pen) {
        guard !isTracePlaying else { return }
        let zPosition = pen.zPosition ?? nextShapeZPosition
        shapes.append(PlaneShape(pen: pen, zPosition: zPosition))
        nextShapeZPosition = max(nextShapeZPosition, zPosition + 1)
        renderRevision += 1
        appendTraceFrameSnapshot()
    }

    public func clear() {
        guard !isTracePlaying else { return }
        shapes.removeAll()
        measurements.removeAll()
        draggablePoints.removeAll()
        nextShapeZPosition = 0
        renderRevision += 1
        appendTraceFrameSnapshot()
    }

    public func setPens(_ newPens: [Pen]) {
        guard !isTracePlaying else { return }
        shapes = newPens.enumerated().map { index, pen in
            PlaneShape(pen: pen, zPosition: pen.zPosition ?? index)
        }
        let maxZ = shapes.map(\.zPosition).max() ?? -1
        nextShapeZPosition = maxZ + 1
        renderRevision += 1
    }

    public func addMeasurement(_ overlay: PlaneMeasurementOverlay) {
        guard !isTracePlaying else { return }
        measurements.append(overlay)
        renderRevision += 1
        appendTraceFrameSnapshot()
    }

    public func setMeasurements(_ overlays: [PlaneMeasurementOverlay]) {
        guard !isTracePlaying else { return }
        measurements = overlays
        renderRevision += 1
    }

    public func setDraggablePoints(_ points: [PlaneDraggablePoint]) {
        guard !isTracePlaying else { return }
        draggablePoints = points
        for point in points {
            LiveViewInputStore.shared.upsertDraggablePoint(id: point.id, x: point.x, y: point.y)
        }
        renderRevision += 1
        appendTraceFrameSnapshot()
    }

    public func updateDraggablePoint(id: String, x: Double, y: Double) {
        guard !isTracePlaying else { return }
        guard let index = draggablePoints.firstIndex(where: { $0.id == id }) else { return }
        let existing = draggablePoints[index]
        guard existing.x != x || existing.y != y else { return }
        draggablePoints[index] = PlaneDraggablePoint(
            id: existing.id,
            x: x,
            y: y,
            radius: existing.radius,
            color: existing.color,
            zPosition: existing.zPosition,
            isEnabled: existing.isEnabled
        )
        LiveViewInputStore.shared.upsertDraggablePoint(id: id, x: x, y: y)
        renderRevision += 1
        appendTraceFrameSnapshot()
    }

    public func setViewOptions(
        isGridVisible: Bool,
        isAxesVisible: Bool,
        isLabelsVisible: Bool,
        isControlsVisible: Bool,
        isHandlesVisible: Bool,
        isHandlesLocked: Bool,
        handleRadius: Double,
        handleColor: UIColor,
        handleSnapMode: String,
        handleSnapGridSpacing: Double,
        isTraceControlsVisible: Bool,
        isTraceCaptureEnabled: Bool,
        traceCaptureOnlyOnChange: Bool,
        tracePlaybackSpeed: Double
    ) {
        guard
            self.isGridVisible != isGridVisible ||
            self.isAxesVisible != isAxesVisible ||
            self.isLabelsVisible != isLabelsVisible ||
            self.isControlsVisible != isControlsVisible ||
            self.isHandlesVisible != isHandlesVisible ||
            self.isHandlesLocked != isHandlesLocked ||
            self.handleRadius != handleRadius ||
            !self.handleColor.isEqual(handleColor) ||
            self.handleSnapMode != handleSnapMode ||
            self.handleSnapGridSpacing != handleSnapGridSpacing ||
            self.isTraceControlsVisible != isTraceControlsVisible ||
            self.isTraceCaptureEnabled != isTraceCaptureEnabled ||
            self.traceCaptureOnlyOnChange != traceCaptureOnlyOnChange ||
            self.tracePlaybackSpeed != tracePlaybackSpeed
        else {
            return
        }
        self.isGridVisible = isGridVisible
        self.isAxesVisible = isAxesVisible
        self.isLabelsVisible = isLabelsVisible
        self.isControlsVisible = isControlsVisible
        self.isHandlesVisible = isHandlesVisible
        self.isHandlesLocked = isHandlesLocked
        self.handleRadius = max(2, handleRadius)
        self.handleColor = handleColor
        self.handleSnapMode = handleSnapMode
        self.handleSnapGridSpacing = max(1, handleSnapGridSpacing)
        self.isTraceControlsVisible = isTraceControlsVisible
        self.isTraceCaptureEnabled = isTraceCaptureEnabled
        self.traceCaptureOnlyOnChange = traceCaptureOnlyOnChange
        self.tracePlaybackSpeed = max(0.25, min(8, tracePlaybackSpeed))
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

    public func setHandlesVisible(_ visible: Bool) {
        guard isHandlesVisible != visible else { return }
        isHandlesVisible = visible
        renderRevision += 1
    }

    public func setHandlesLocked(_ locked: Bool) {
        guard isHandlesLocked != locked else { return }
        isHandlesLocked = locked
        renderRevision += 1
    }

    public func setHandleSnapMode(_ mode: String) {
        guard handleSnapMode != mode else { return }
        handleSnapMode = mode
        renderRevision += 1
    }

    public func setTraceCaptureEnabled(_ enabled: Bool) {
        guard isTraceCaptureEnabled != enabled else { return }
        isTraceCaptureEnabled = enabled
        isTraceControlsVisible = enabled
        if !enabled {
            pauseTracePlayback()
        }
        renderRevision += 1
    }

    public func clearTraceHistory() {
        traceFrames.removeAll()
        traceFrameCount = 0
        tracePlaybackIndex = 0
        lastTraceSnapshotKey = nil
        isTracePlaying = false
        traceTimer?.invalidate()
        traceTimer = nil
        renderRevision += 1
    }

    public func resetTracePlayback() {
        pauseTracePlayback()
        guard !traceFrames.isEmpty else { return }
        applyTraceFrame(at: 0)
    }

    public func stepTraceForward() {
        pauseTracePlayback()
        guard tracePlaybackIndex + 1 < traceFrames.count else { return }
        applyTraceFrame(at: tracePlaybackIndex + 1)
    }

    public func stepTraceBackward() {
        pauseTracePlayback()
        guard tracePlaybackIndex - 1 >= 0 else { return }
        applyTraceFrame(at: tracePlaybackIndex - 1)
    }

    public func playTracePlayback(fps: Double = 4) {
        guard traceFrames.count > 1 else { return }
        if tracePlaybackIndex >= traceFrames.count - 1 {
            applyTraceFrame(at: 0)
        }
        pauseTracePlayback()
        isTracePlaying = true
        let interval = 1.0 / max(1, fps * tracePlaybackSpeed)
        traceTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                if self.tracePlaybackIndex + 1 >= self.traceFrames.count {
                    self.pauseTracePlayback()
                    return
                }
                self.applyTraceFrame(at: self.tracePlaybackIndex + 1)
            }
        }
    }

    public func pauseTracePlayback() {
        if traceTimer != nil {
            traceTimer?.invalidate()
            traceTimer = nil
        }
        isTracePlaying = false
    }

    public func setTraceCaptureOnlyOnChange(_ value: Bool) {
        guard traceCaptureOnlyOnChange != value else { return }
        traceCaptureOnlyOnChange = value
        renderRevision += 1
    }

    public func setTracePlaybackSpeed(_ speed: Double) {
        let clamped = max(0.25, min(8, speed))
        guard tracePlaybackSpeed != clamped else { return }
        tracePlaybackSpeed = clamped
        if isTracePlaying {
            playTracePlayback()
        } else {
            renderRevision += 1
        }
    }

    private func appendTraceFrameSnapshot() {
        guard isTraceCaptureEnabled, !isApplyingTraceFrame else { return }

        let frame = PlaneTraceFrame(
            pens: shapes.sorted(by: { $0.zPosition < $1.zPosition }).map(\.pen),
            measurements: measurements,
            draggablePoints: draggablePoints
        )

        if traceCaptureOnlyOnChange {
            let snapshotKey = makeTraceSnapshotKey(frame)
            if snapshotKey == lastTraceSnapshotKey {
                return
            }
            lastTraceSnapshotKey = snapshotKey
        }

        traceFrames.append(frame)
        if traceFrames.count > maxTraceFrames {
            traceFrames.removeFirst(traceFrames.count - maxTraceFrames)
        }
        traceFrameCount = traceFrames.count
        tracePlaybackIndex = max(0, traceFrames.count - 1)
    }

    private func applyTraceFrame(at index: Int) {
        guard traceFrames.indices.contains(index) else { return }
        isApplyingTraceFrame = true
        let frame = traceFrames[index]
        shapes = frame.pens.enumerated().map { idx, pen in
            PlaneShape(pen: pen, zPosition: pen.zPosition ?? idx)
        }
        measurements = frame.measurements
        draggablePoints = frame.draggablePoints
        for point in frame.draggablePoints {
            LiveViewInputStore.shared.upsertDraggablePoint(id: point.id, x: point.x, y: point.y)
        }
        tracePlaybackIndex = index
        let maxZ = shapes.map(\.zPosition).max() ?? -1
        nextShapeZPosition = maxZ + 1
        isApplyingTraceFrame = false
        renderRevision += 1
    }

    private func makeTraceSnapshotKey(_ frame: PlaneTraceFrame) -> String {
        var keyParts: [String] = []
        keyParts.append("P\(frame.pens.count)")
        for pen in frame.pens {
            keyParts.append("W\(Int((pen.lineWidth * 100).rounded()))")
            keyParts.append("Z\(pen.zPosition ?? -1)")
            keyParts.append("S\(pen.steps.count)")
            for step in pen.steps {
                keyParts.append(step.instruction.rawValue)
                keyParts.append(String(format: "%.2f", step.first))
                keyParts.append(String(format: "%.2f", step.second ?? 0))
            }
        }

        keyParts.append("M\(frame.measurements.count)")
        for measurement in frame.measurements {
            keyParts.append(measurement.id)
            keyParts.append(measurement.text)
            keyParts.append(String(format: "%.2f", measurement.x))
            keyParts.append(String(format: "%.2f", measurement.y))
        }

        keyParts.append("D\(frame.draggablePoints.count)")
        for point in frame.draggablePoints {
            keyParts.append(point.id)
            keyParts.append(String(format: "%.2f", point.x))
            keyParts.append(String(format: "%.2f", point.y))
            keyParts.append(point.isEnabled ? "1" : "0")
        }

        return keyParts.joined(separator: "|")
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
    @State private var activeDraggedPointID: String?
    @State private var activeDraggedPointAnchor: (x: Double, y: Double)?

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
                draggablePointHandles(center: center)
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

                    if model.isTraceControlsVisible && model.isTraceCaptureEnabled {
                        tracePlaybackPanel
                    }
                }
            }
            .background(.white)
            .onDisappear {
                model.pauseTracePlayback()
            }
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
            Toggle("Show Handles", isOn: Binding(
                get: { model.isHandlesVisible },
                set: { model.setHandlesVisible($0) }
            ))
            Toggle("Lock Handles", isOn: Binding(
                get: { model.isHandlesLocked },
                set: { model.setHandlesLocked($0) }
            ))
            Toggle("Trace Capture", isOn: Binding(
                get: { model.isTraceCaptureEnabled },
                set: { model.setTraceCaptureEnabled($0) }
            ))
            Toggle("Capture Changed Only", isOn: Binding(
                get: { model.traceCaptureOnlyOnChange },
                set: { model.setTraceCaptureOnlyOnChange($0) }
            ))

            Picker("Handle Snap", selection: Binding(
                get: { model.handleSnapMode },
                set: { model.setHandleSnapMode($0) }
            )) {
                Text("None").tag("none")
                Text("Grid").tag("grid")
                Text("X Axis").tag("xAxis")
                Text("Y Axis").tag("yAxis")
                Text("Axes").tag("axes")
            }
            .pickerStyle(.menu)
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

    private var tracePlaybackPanel: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 6) {
                Image(systemName: "timeline.selection")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(Color.gray.opacity(0.8))
                Text("Trace")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.gray.opacity(0.9))
                Spacer(minLength: 4)
                Text("\(min(model.tracePlaybackIndex + 1, max(1, model.traceFrameCount)))/\(max(1, model.traceFrameCount))")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundStyle(Color.gray.opacity(0.8))
            }
            .frame(width: inputControlWidth, alignment: .leading)

            HStack(spacing: 10) {
                Button {
                    model.stepTraceBackward()
                } label: {
                    Image(systemName: "backward.frame.fill")
                }
                .buttonStyle(.plain)

                Button {
                    if model.isTracePlaying {
                        model.pauseTracePlayback()
                    } else {
                        model.playTracePlayback()
                    }
                } label: {
                    Image(systemName: model.isTracePlaying ? "pause.circle.fill" : "play.circle.fill")
                }
                .buttonStyle(.plain)

                Button {
                    model.stepTraceForward()
                } label: {
                    Image(systemName: "forward.frame.fill")
                }
                .buttonStyle(.plain)

                Button {
                    model.resetTracePlayback()
                } label: {
                    Image(systemName: "gobackward")
                }
                .buttonStyle(.plain)

                Button {
                    model.clearTraceHistory()
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.plain)
            }
            .font(.system(size: 16, weight: .semibold))
            .foregroundStyle(Color.black.opacity(0.75))
            .frame(width: inputControlWidth, alignment: .leading)

            Picker("Speed", selection: Binding(
                get: { model.tracePlaybackSpeed },
                set: { model.setTracePlaybackSpeed($0) }
            )) {
                Text("0.5x").tag(0.5)
                Text("1x").tag(1.0)
                Text("2x").tag(2.0)
                Text("4x").tag(4.0)
            }
            .pickerStyle(.segmented)
            .frame(width: inputControlWidth)
        }
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
    private func draggablePointHandles(center: CGPoint) -> some View {
        if model.isHandlesVisible {
            ForEach(model.draggablePoints.sorted(by: { $0.zPosition < $1.zPosition })) { point in
                Circle()
                    .fill(Color(uiColor: point.color).opacity(point.isEnabled ? 0.85 : 0.35))
                    .overlay(
                        Circle()
                            .stroke(Color.white, lineWidth: 1.5)
                    )
                    .frame(width: max(8, point.radius * 2), height: max(8, point.radius * 2))
                    .position(x: center.x + point.x, y: center.y - point.y)
                    .zIndex(Double(point.zPosition))
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                handlePointDragChanged(point: point, value: value)
                            }
                            .onEnded { _ in
                                handlePointDragEnded(pointID: point.id)
                            }
                    )
            }
        }
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

    private func handlePointDragChanged(point: PlaneDraggablePoint, value: DragGesture.Value) {
        guard model.isHandlesVisible, !model.isHandlesLocked, point.isEnabled else { return }

        if activeDraggedPointID != point.id {
            activeDraggedPointID = point.id
            activeDraggedPointAnchor = (x: point.x, y: point.y)
        }

        guard let anchor = activeDraggedPointAnchor else { return }
        let proposed = (
            x: anchor.x + value.translation.width,
            y: anchor.y - value.translation.height
        )
        let snapped = applySnap(proposed)
        model.updateDraggablePoint(id: point.id, x: snapped.x, y: snapped.y)
    }

    private func handlePointDragEnded(pointID: String) {
        guard activeDraggedPointID == pointID else { return }
        activeDraggedPointID = nil
        activeDraggedPointAnchor = nil
    }

    private func applySnap(_ point: (x: Double, y: Double)) -> (x: Double, y: Double) {
        switch model.handleSnapMode {
        case "grid":
            let spacing = max(1, model.handleSnapGridSpacing)
            return (
                x: (point.x / spacing).rounded() * spacing,
                y: (point.y / spacing).rounded() * spacing
            )
        case "xAxis":
            return (x: point.x, y: 0)
        case "yAxis":
            return (x: 0, y: point.y)
        case "axes":
            if abs(point.x) <= abs(point.y) {
                return (x: 0, y: point.y)
            }
            return (x: point.x, y: 0)
        default:
            return point
        }
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
