import UIKit
import PlaygroundSupport
import BookCore

public typealias Pen = BookCore.Pen

public struct Point: Equatable {
    public let x: Double
    public let y: Double

    public init(x: Double, y: Double) {
        self.x = x
        self.y = y
    }
}

public struct Line: Equatable {
    public let start: Point
    public let end: Point

    public init(start: Point, end: Point) {
        self.start = start
        self.end = end
    }
}

public struct Circle: Equatable {
    public let center: Point
    public let radius: Double

    public init(center: Point, radius: Double) {
        self.center = center
        self.radius = radius
    }
}

public struct Triangle: Equatable {
    public let a: Point
    public let b: Point
    public let c: Point

    public init(a: Point, b: Point, c: Point) {
        self.a = a
        self.b = b
        self.c = c
    }
}

public struct Polygon: Equatable {
    public let vertices: [Point]

    public init(vertices: [Point]) {
        self.vertices = vertices
    }
}

public struct Transform2D: Equatable {
    public let a: Double
    public let b: Double
    public let c: Double
    public let d: Double
    public let tx: Double
    public let ty: Double

    public init(a: Double, b: Double, c: Double, d: Double, tx: Double, ty: Double) {
        self.a = a
        self.b = b
        self.c = c
        self.d = d
        self.tx = tx
        self.ty = ty
    }

    public static let identity = Transform2D(a: 1, b: 0, c: 0, d: 1, tx: 0, ty: 0)

    public static func translation(dx: Double, dy: Double) -> Transform2D {
        Transform2D(a: 1, b: 0, c: 0, d: 1, tx: dx, ty: dy)
    }

    public static func rotation(degrees: Double, around center: Point = Point(x: 0, y: 0)) -> Transform2D {
        let radians = degrees * .pi / 180
        let cosTheta = cos(radians)
        let sinTheta = sin(radians)
        let tx = center.x - (cosTheta * center.x) + (sinTheta * center.y)
        let ty = center.y - (sinTheta * center.x) - (cosTheta * center.y)
        return Transform2D(a: cosTheta, b: sinTheta, c: -sinTheta, d: cosTheta, tx: tx, ty: ty)
    }

    public static func scaling(factor: Double, around center: Point = Point(x: 0, y: 0)) -> Transform2D {
        Transform2D(
            a: factor,
            b: 0,
            c: 0,
            d: factor,
            tx: center.x * (1 - factor),
            ty: center.y * (1 - factor)
        )
    }

    public static func reflectionAcrossX() -> Transform2D {
        Transform2D(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 0)
    }

    public static func reflectionAcrossY() -> Transform2D {
        Transform2D(a: -1, b: 0, c: 0, d: 1, tx: 0, ty: 0)
    }

    public func applying(to point: Point) -> Point {
        Point(
            x: (a * point.x) + (c * point.y) + tx,
            y: (b * point.x) + (d * point.y) + ty
        )
    }

    // Returns a transform equivalent to applying `self`, then `next`.
    public func followed(by next: Transform2D) -> Transform2D {
        Transform2D(
            a: (next.a * a) + (next.c * b),
            b: (next.b * a) + (next.d * b),
            c: (next.a * c) + (next.c * d),
            d: (next.b * c) + (next.d * d),
            tx: (next.a * tx) + (next.c * ty) + next.tx,
            ty: (next.b * tx) + (next.d * ty) + next.ty
        )
    }

    public func concatenating(_ next: Transform2D) -> Transform2D {
        followed(by: next)
    }
}

public extension Point {
    func transformed(by transform: Transform2D) -> Point {
        transform.applying(to: self)
    }
}

public extension Line {
    func transformed(by transform: Transform2D) -> Line {
        Line(
            start: start.transformed(by: transform),
            end: end.transformed(by: transform)
        )
    }
}

public extension Circle {
    func transformed(by transform: Transform2D) -> Circle {
        let transformedCenter = center.transformed(by: transform)
        let transformedEdge = Point(x: center.x + radius, y: center.y).transformed(by: transform)
        let transformedRadius = distance(transformedCenter, transformedEdge)
        return Circle(center: transformedCenter, radius: transformedRadius)
    }
}

public extension Triangle {
    func transformed(by transform: Transform2D) -> Triangle {
        Triangle(
            a: a.transformed(by: transform),
            b: b.transformed(by: transform),
            c: c.transformed(by: transform)
        )
    }
}

public extension Polygon {
    func transformed(by transform: Transform2D) -> Polygon {
        Polygon(vertices: vertices.map { $0.transformed(by: transform) })
    }
}

public func distance(_ first: Point, _ second: Point) -> Double {
    hypot(second.x - first.x, second.y - first.y)
}

public func midpoint(_ first: Point, _ second: Point) -> Point {
    Point(x: (first.x + second.x) / 2, y: (first.y + second.y) / 2)
}

public func slope(_ first: Point, _ second: Point) -> Double? {
    let dx = second.x - first.x
    guard dx != 0 else { return nil }
    return (second.y - first.y) / dx
}

public func translate(_ point: Point, dx: Double, dy: Double) -> Point {
    point.transformed(by: .translation(dx: dx, dy: dy))
}

public func rotate(_ point: Point, around center: Point = Point(x: 0, y: 0), degrees: Double) -> Point {
    point.transformed(by: .rotation(degrees: degrees, around: center))
}

public func scale(_ point: Point, around center: Point = Point(x: 0, y: 0), factor: Double) -> Point {
    point.transformed(by: .scaling(factor: factor, around: center))
}

public func translate(_ line: Line, dx: Double, dy: Double) -> Line {
    line.transformed(by: .translation(dx: dx, dy: dy))
}

public func rotate(_ line: Line, around center: Point = Point(x: 0, y: 0), degrees: Double) -> Line {
    line.transformed(by: .rotation(degrees: degrees, around: center))
}

public func scale(_ line: Line, around center: Point = Point(x: 0, y: 0), factor: Double) -> Line {
    line.transformed(by: .scaling(factor: factor, around: center))
}

public func translate(_ circle: Circle, dx: Double, dy: Double) -> Circle {
    circle.transformed(by: .translation(dx: dx, dy: dy))
}

public func rotate(_ circle: Circle, around center: Point = Point(x: 0, y: 0), degrees: Double) -> Circle {
    circle.transformed(by: .rotation(degrees: degrees, around: center))
}

public func scale(_ circle: Circle, around center: Point = Point(x: 0, y: 0), factor: Double) -> Circle {
    circle.transformed(by: .scaling(factor: factor, around: center))
}

public func translate(_ triangle: Triangle, dx: Double, dy: Double) -> Triangle {
    triangle.transformed(by: .translation(dx: dx, dy: dy))
}

public func rotate(_ triangle: Triangle, around center: Point = Point(x: 0, y: 0), degrees: Double) -> Triangle {
    triangle.transformed(by: .rotation(degrees: degrees, around: center))
}

public func scale(_ triangle: Triangle, around center: Point = Point(x: 0, y: 0), factor: Double) -> Triangle {
    triangle.transformed(by: .scaling(factor: factor, around: center))
}

public func translate(_ polygon: Polygon, dx: Double, dy: Double) -> Polygon {
    polygon.transformed(by: .translation(dx: dx, dy: dy))
}

public func rotate(_ polygon: Polygon, around center: Point = Point(x: 0, y: 0), degrees: Double) -> Polygon {
    polygon.transformed(by: .rotation(degrees: degrees, around: center))
}

public func scale(_ polygon: Polygon, around center: Point = Point(x: 0, y: 0), factor: Double) -> Polygon {
    polygon.transformed(by: .scaling(factor: factor, around: center))
}

public func addPoint(
    _ point: Point,
    color: UIColor = .systemBlue,
    radius: Double = 4,
    zPosition: Int? = nil
) {
    var pen = Pen()
    pen.penColor = color
    pen.fillColor = color
    pen.lineWidth = 1
    pen.zPosition = zPosition
    pen.goto(x: point.x, y: point.y)
    pen.drawCircle(radius: CGFloat(radius))
    addShape(pen: pen)
}

public func addLine(
    _ line: Line,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    var pen = Pen()
    pen.penColor = color
    pen.lineWidth = lineWidth
    pen.zPosition = zPosition
    pen.goto(x: line.start.x, y: line.start.y)
    pen.drawTo(dx: line.end.x - line.start.x, dy: line.end.y - line.start.y)
    addShape(pen: pen)
}

public func addCircle(
    _ circle: Circle,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    fillColor: UIColor = .clear,
    zPosition: Int? = nil
) {
    var pen = Pen()
    pen.penColor = color
    pen.fillColor = fillColor
    pen.lineWidth = lineWidth
    pen.zPosition = zPosition
    pen.goto(x: circle.center.x, y: circle.center.y)
    pen.drawCircle(radius: CGFloat(circle.radius))
    addShape(pen: pen)
}

public func addTriangle(
    _ triangle: Triangle,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    fillColor: UIColor = .clear,
    zPosition: Int? = nil
) {
    addPolygon(
        Polygon(vertices: [triangle.a, triangle.b, triangle.c]),
        color: color,
        lineWidth: lineWidth,
        fillColor: fillColor,
        zPosition: zPosition
    )
}

public func addPolygon(
    _ polygon: Polygon,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    fillColor: UIColor = .clear,
    zPosition: Int? = nil
) {
    guard let first = polygon.vertices.first, polygon.vertices.count > 1 else { return }

    var pen = Pen()
    pen.penColor = color
    pen.fillColor = fillColor
    pen.lineWidth = lineWidth
    pen.zPosition = zPosition
    pen.goto(x: first.x, y: first.y)

    for vertex in polygon.vertices.dropFirst() {
        let current = pen.currentPosition()
        pen.drawTo(dx: vertex.x - Double(current.x), dy: vertex.y - Double(current.y))
    }

    let finalPoint = pen.currentPosition()
    pen.drawTo(dx: first.x - Double(finalPoint.x), dy: first.y - Double(finalPoint.y))
    addShape(pen: pen)
}

private enum LiveViewMessageKey {
    static let type = "type"
    static let shapes = "shapes"
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
    static let registerInput = "registerInput"
    static let inputID = "inputID"
    static let inputTitle = "inputTitle"
    static let inputKind = "inputKind"
    static let inputText = "inputText"
    static let inputDecimal = "inputDecimal"
    static let inputNumber = "inputNumber"
}

private var inputCounter = 0
private var sceneRenderBlock: (() -> Void)?
private var isRenderingScene = false
private var scenePens: [Pen] = []
private var sceneObserverInstalled = false
private var hasRegisteredInputIDs: Set<String> = []

public func Scene(_ content: @escaping () -> Void) {
    sceneRenderBlock = content

    if !sceneObserverInstalled {
        sceneObserverInstalled = true
        onInputChange {
            if isRenderingScene { return }
            rerenderScene()
        }
    }

    rerenderScene()
}

public func addShape(pen: Pen) {
    if isRenderingScene {
        scenePens.append(pen)
        return
    }

    let message: PlaygroundValue = .dictionary([
        LiveViewMessageKey.type: .string(LiveViewMessageKey.addShape),
        LiveViewMessageKey.shapes: .array([encodePen(pen)])
    ])

    sendToLiveView(message)
}

public func Input(text: String, label: String? = nil) -> String {
    let inputID = label ?? nextInputID(prefix: "text")
    let inputTitle = label ?? inputID

    registerInputIfNeeded(
        id: inputID,
        title: inputTitle,
        kind: "text",
        payloadKey: LiveViewMessageKey.inputText,
        payloadValue: .string(text)
    )

    return currentTextValue(for: inputID, defaultValue: text)
}

public func Input(decimal: Double, label: String? = nil) -> Double {
    let inputID = label ?? nextInputID(prefix: "decimal")
    let inputTitle = label ?? inputID

    registerInputIfNeeded(
        id: inputID,
        title: inputTitle,
        kind: "decimal",
        payloadKey: LiveViewMessageKey.inputDecimal,
        payloadValue: .floatingPoint(decimal)
    )

    return currentDecimalValue(for: inputID, defaultValue: decimal)
}

public func Input(number: Int, label: String? = nil) -> CGFloat {
    let inputID = label ?? nextInputID(prefix: "number")
    let inputTitle = label ?? inputID

    registerInputIfNeeded(
        id: inputID,
        title: inputTitle,
        kind: "number",
        payloadKey: LiveViewMessageKey.inputNumber,
        payloadValue: .integer(number)
    )

    return currentNumberValue(for: inputID, defaultValue: number)
}

public func onInputChange(_ handler: @escaping () -> Void) {
    Task { @MainActor in
        LiveViewInputStore.shared.addObserver(handler)
    }
}

@MainActor public func inputDecimal(id: String) -> Double {
    LiveViewInputStore.shared.decimalValue(for: id)
}

@MainActor public func inputNumber(id: String) -> Int {
    LiveViewInputStore.shared.numberValue(for: id)
}

@MainActor public func inputText(id: String) -> String {
    LiveViewInputStore.shared.textValue(for: id)
}

private func rerenderScene() {
    guard let block = sceneRenderBlock else { return }

    isRenderingScene = true
    scenePens.removeAll(keepingCapacity: true)
    block()
    isRenderingScene = false

    let encodedPens = scenePens.map(encodePen)
    let message: PlaygroundValue = .dictionary([
        LiveViewMessageKey.type: .string(LiveViewMessageKey.setShapes),
        LiveViewMessageKey.shapes: .array(encodedPens)
    ])

    sendToLiveView(message)
}

private func nextInputID(prefix: String) -> String {
    inputCounter += 1
    return "\(prefix)_\(inputCounter)"
}

private func registerInputIfNeeded(id: String, title: String, kind: String, payloadKey: String, payloadValue: PlaygroundValue) {
    guard !hasRegisteredInputIDs.contains(id) else { return }
    hasRegisteredInputIDs.insert(id)

    var dictionary: [String: PlaygroundValue] = [
        LiveViewMessageKey.type: .string(LiveViewMessageKey.registerInput),
        LiveViewMessageKey.inputID: .string(id),
        LiveViewMessageKey.inputTitle: .string(title),
        LiveViewMessageKey.inputKind: .string(kind)
    ]
    dictionary[payloadKey] = payloadValue

    sendToLiveView(.dictionary(dictionary))
}

public func Input(text: String, id: String?) -> String {
    Input(text: text, label: id)
}

public func Input(decimal: Double, id: String?) -> Double {
    Input(decimal: decimal, label: id)
}

public func Input(number: Int, id: String?) -> CGFloat {
    Input(number: number, label: id)
}

private func currentTextValue(for id: String, defaultValue: String) -> String {
    MainActor.assumeIsolated {
        LiveViewInputStore.shared.inputValue(for: id)?.textValue ?? defaultValue
    }
}

private func currentDecimalValue(for id: String, defaultValue: Double) -> Double {
    MainActor.assumeIsolated {
        LiveViewInputStore.shared.inputValue(for: id)?.decimalValue ?? defaultValue
    }
}

private func currentNumberValue(for id: String, defaultValue: Int) -> CGFloat {
    MainActor.assumeIsolated {
        CGFloat(LiveViewInputStore.shared.inputValue(for: id)?.numberValue ?? defaultValue)
    }
}

private func sendToLiveView(_ message: PlaygroundValue) {
    if let proxy = PlaygroundPage.current.liveView as? PlaygroundRemoteLiveViewProxy {
        proxy.send(message)
        return
    }

    Task { @MainActor in
        LiveViewMessageRouter.shared.send(message)
    }
}

private func encodePen(_ pen: Pen) -> PlaygroundValue {
    let stepsValue: [PlaygroundValue] = pen.steps.map { step in
        var dictionary: [String: PlaygroundValue] = [
            LiveViewMessageKey.stepInstruction: .string(step.instruction.rawValue),
            LiveViewMessageKey.stepFirst: .floatingPoint(step.first)
        ]

        if let second = step.second {
            dictionary[LiveViewMessageKey.stepSecond] = .floatingPoint(second)
        }

        return .dictionary(dictionary)
    }

    var dictionary: [String: PlaygroundValue] = [
        LiveViewMessageKey.steps: .array(stepsValue),
        LiveViewMessageKey.lineWidth: .floatingPoint(Double(pen.lineWidth)),
        LiveViewMessageKey.penColor: encodeColor(pen.penColor),
        LiveViewMessageKey.fillColor: encodeColor(pen.fillColor)
    ]

    if let zPosition = pen.zPosition {
        dictionary[LiveViewMessageKey.zPosition] = .integer(zPosition)
    }

    return .dictionary(dictionary)
}

private func encodeColor(_ color: UIColor) -> PlaygroundValue {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0

    color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)

    return .dictionary([
        LiveViewMessageKey.colorRed: .floatingPoint(Double(red)),
        LiveViewMessageKey.colorGreen: .floatingPoint(Double(green)),
        LiveViewMessageKey.colorBlue: .floatingPoint(Double(blue)),
        LiveViewMessageKey.colorAlpha: .floatingPoint(Double(alpha))
    ])
}
