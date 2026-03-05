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

public enum ParabolaAxis {
    case vertical
    case horizontal
}

public enum HyperbolaAxis {
    case horizontal
    case vertical
}

public struct PlotSafetyConfiguration: Equatable {
    public var maxSamplesPerCurve: Int
    public var maxTotalSamplesPerScene: Int
    public var strictValidation: Bool

    public init(
        maxSamplesPerCurve: Int = 4000,
        maxTotalSamplesPerScene: Int = 30000,
        strictValidation: Bool = false
    ) {
        self.maxSamplesPerCurve = maxSamplesPerCurve
        self.maxTotalSamplesPerScene = maxTotalSamplesPerScene
        self.strictValidation = strictValidation
    }
}

public func setPlotSafetyConfiguration(_ configuration: PlotSafetyConfiguration) {
    plotSafetyConfiguration = configuration
}

public func currentPlotSafetyConfiguration() -> PlotSafetyConfiguration {
    plotSafetyConfiguration
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

public func centroid(_ triangle: Triangle) -> Point {
    Point(
        x: (triangle.a.x + triangle.b.x + triangle.c.x) / 3,
        y: (triangle.a.y + triangle.b.y + triangle.c.y) / 3
    )
}

public func incenter(_ triangle: Triangle) -> Point? {
    let sideA = distance(triangle.b, triangle.c)
    let sideB = distance(triangle.a, triangle.c)
    let sideC = distance(triangle.a, triangle.b)
    let perimeter = sideA + sideB + sideC
    guard perimeter > 0 else { return nil }

    return Point(
        x: (sideA * triangle.a.x + sideB * triangle.b.x + sideC * triangle.c.x) / perimeter,
        y: (sideA * triangle.a.y + sideB * triangle.b.y + sideC * triangle.c.y) / perimeter
    )
}

public func circumcenter(_ triangle: Triangle) -> Point? {
    let ax = triangle.a.x
    let ay = triangle.a.y
    let bx = triangle.b.x
    let by = triangle.b.y
    let cx = triangle.c.x
    let cy = triangle.c.y

    let d = 2 * (ax * (by - cy) + bx * (cy - ay) + cx * (ay - by))
    guard abs(d) > 1e-10 else { return nil }

    let ax2ay2 = ax * ax + ay * ay
    let bx2by2 = bx * bx + by * by
    let cx2cy2 = cx * cx + cy * cy

    let ux = (ax2ay2 * (by - cy) + bx2by2 * (cy - ay) + cx2cy2 * (ay - by)) / d
    let uy = (ax2ay2 * (cx - bx) + bx2by2 * (ax - cx) + cx2cy2 * (bx - ax)) / d
    return Point(x: ux, y: uy)
}

public func orthocenter(_ triangle: Triangle) -> Point? {
    let altitudeFromA = perpendicularLine(
        through: triangle.a,
        to: Line(start: triangle.b, end: triangle.c),
        length: 2000
    )
    let altitudeFromB = perpendicularLine(
        through: triangle.b,
        to: Line(start: triangle.a, end: triangle.c),
        length: 2000
    )
    return intersection(altitudeFromA, altitudeFromB)
}

public func intersection(_ first: Line, _ second: Line) -> Point? {
    let x1 = first.start.x
    let y1 = first.start.y
    let x2 = first.end.x
    let y2 = first.end.y
    let x3 = second.start.x
    let y3 = second.start.y
    let x4 = second.end.x
    let y4 = second.end.y

    let denominator = (x1 - x2) * (y3 - y4) - (y1 - y2) * (x3 - x4)
    guard abs(denominator) > 1e-10 else { return nil }

    let xNumerator = (x1 * y2 - y1 * x2) * (x3 - x4) - (x1 - x2) * (x3 * y4 - y3 * x4)
    let yNumerator = (x1 * y2 - y1 * x2) * (y3 - y4) - (y1 - y2) * (x3 * y4 - y3 * x4)
    return Point(x: xNumerator / denominator, y: yNumerator / denominator)
}

public func perpendicularLine(through point: Point, to line: Line, length: Double = 500) -> Line {
    let dx = line.end.x - line.start.x
    let dy = line.end.y - line.start.y
    let magnitude = hypot(dx, dy)

    guard magnitude > 1e-10 else {
        return Line(start: point, end: Point(x: point.x, y: point.y + length))
    }

    let ux = -dy / magnitude
    let uy = dx / magnitude
    let half = length / 2
    return Line(
        start: Point(x: point.x - ux * half, y: point.y - uy * half),
        end: Point(x: point.x + ux * half, y: point.y + uy * half)
    )
}

public func perpendicularBisector(of line: Line, length: Double = 500) -> Line {
    let mid = midpoint(line.start, line.end)
    return perpendicularLine(through: mid, to: line, length: length)
}

public func angleBisector(
    at vertex: Point,
    through firstPoint: Point,
    and secondPoint: Point,
    length: Double = 500
) -> Line? {
    let v1x = firstPoint.x - vertex.x
    let v1y = firstPoint.y - vertex.y
    let v2x = secondPoint.x - vertex.x
    let v2y = secondPoint.y - vertex.y

    let m1 = hypot(v1x, v1y)
    let m2 = hypot(v2x, v2y)
    guard m1 > 1e-10, m2 > 1e-10 else { return nil }

    let u1x = v1x / m1
    let u1y = v1y / m1
    let u2x = v2x / m2
    let u2y = v2y / m2

    let dirX = u1x + u2x
    let dirY = u1y + u2y
    let dirMagnitude = hypot(dirX, dirY)
    guard dirMagnitude > 1e-10 else { return nil }

    let ux = dirX / dirMagnitude
    let uy = dirY / dirMagnitude
    return Line(
        start: vertex,
        end: Point(x: vertex.x + ux * length, y: vertex.y + uy * length)
    )
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

public func plotParametric(
    tMin: Double,
    tMax: Double,
    samples: Int = 300,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil,
    equation: (Double) -> Point?
) {
    guard tMin.isFinite, tMax.isFinite else { return }

    let domainMin = min(tMin, tMax)
    let domainMax = max(tMin, tMax)
    let sampleCount = sanitizedSampleCount(samples, minimum: 2, context: "plotParametric")
    let budgetedSampleCount = reserveSceneSampleBudget(sampleCount)
    guard budgetedSampleCount >= 2 else { return }

    var pen = Pen()
    pen.penColor = color
    pen.lineWidth = lineWidth
    pen.zPosition = zPosition

    let step = (domainMax - domainMin) / Double(budgetedSampleCount - 1)
    var previousPoint: Point?

    for index in 0..<budgetedSampleCount {
        let t = domainMin + (Double(index) * step)
        guard let point = equation(t), point.x.isFinite, point.y.isFinite else {
            previousPoint = nil
            continue
        }

        if let previousPoint {
            pen.drawTo(dx: point.x - previousPoint.x, dy: point.y - previousPoint.y)
        } else {
            pen.goto(x: point.x, y: point.y)
        }

        previousPoint = point
    }

    addShape(pen: pen)
}

public func plotFunction(
    xMin: Double,
    xMax: Double,
    samples: Int = 300,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil,
    function: (Double) -> Double?
) {
    plotParametric(
        tMin: xMin,
        tMax: xMax,
        samples: samples,
        color: color,
        lineWidth: lineWidth,
        zPosition: zPosition
    ) { x in
        guard let y = function(x) else { return nil }
        return Point(x: x, y: y)
    }
}

public func sampleParametric(
    tMin: Double,
    tMax: Double,
    samples: Int = 300,
    equation: (Double) -> Point?
) -> [Point] {
    guard tMin.isFinite, tMax.isFinite else { return [] }

    let domainMin = min(tMin, tMax)
    let domainMax = max(tMin, tMax)
    let sampleCount = sanitizedSampleCount(samples, minimum: 2, context: "sampleParametric")
    let budgetedSampleCount = reserveSceneSampleBudget(sampleCount)
    guard budgetedSampleCount >= 2 else { return [] }

    let step = (domainMax - domainMin) / Double(budgetedSampleCount - 1)
    var result: [Point] = []
    result.reserveCapacity(budgetedSampleCount)

    for index in 0..<budgetedSampleCount {
        let t = domainMin + (Double(index) * step)
        guard let point = equation(t), point.x.isFinite, point.y.isFinite else { continue }
        result.append(point)
    }

    return result
}

public func sampleFunction(
    xMin: Double,
    xMax: Double,
    samples: Int = 300,
    function: (Double) -> Double?
) -> [Point] {
    sampleParametric(tMin: xMin, tMax: xMax, samples: samples) { x in
        guard let y = function(x) else { return nil }
        return Point(x: x, y: y)
    }
}

public func addSamplePoints(
    _ points: [Point],
    every stride: Int = 1,
    color: UIColor = .systemRed,
    radius: Double = 3,
    zPosition: Int? = nil
) {
    let safeStride = max(1, stride)
    for (index, point) in points.enumerated() where index % safeStride == 0 {
        addPoint(point, color: color, radius: radius, zPosition: zPosition)
    }
}

public func tangentLineToFunction(
    atX x: Double,
    delta: Double = 0.001,
    length: Double = 140,
    function: (Double) -> Double?
) -> Line? {
    guard
        let y = function(x),
        let yMinus = function(x - delta),
        let yPlus = function(x + delta)
    else {
        return nil
    }

    let dy = yPlus - yMinus
    let dx = 2 * delta
    let magnitude = hypot(dx, dy)
    guard magnitude > 1e-10 else { return nil }

    let ux = dx / magnitude
    let uy = dy / magnitude
    let half = length / 2
    let point = Point(x: x, y: y)

    return Line(
        start: Point(x: point.x - ux * half, y: point.y - uy * half),
        end: Point(x: point.x + ux * half, y: point.y + uy * half)
    )
}

public func addTangentToFunction(
    atX x: Double,
    delta: Double = 0.001,
    length: Double = 140,
    color: UIColor = .systemOrange,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil,
    function: (Double) -> Double?
) {
    guard let tangent = tangentLineToFunction(atX: x, delta: delta, length: length, function: function) else { return }
    addLine(tangent, color: color, lineWidth: lineWidth, zPosition: zPosition)
}

public func tangentLineToParametric(
    atT t: Double,
    delta: Double = 0.001,
    length: Double = 140,
    equation: (Double) -> Point?
) -> Line? {
    guard
        let point = equation(t),
        let pointMinus = equation(t - delta),
        let pointPlus = equation(t + delta)
    else {
        return nil
    }

    let dx = pointPlus.x - pointMinus.x
    let dy = pointPlus.y - pointMinus.y
    let magnitude = hypot(dx, dy)
    guard magnitude > 1e-10 else { return nil }

    let ux = dx / magnitude
    let uy = dy / magnitude
    let half = length / 2

    return Line(
        start: Point(x: point.x - ux * half, y: point.y - uy * half),
        end: Point(x: point.x + ux * half, y: point.y + uy * half)
    )
}

public func addTangentToParametric(
    atT t: Double,
    delta: Double = 0.001,
    length: Double = 140,
    color: UIColor = .systemOrange,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil,
    equation: (Double) -> Point?
) {
    guard let tangent = tangentLineToParametric(atT: t, delta: delta, length: length, equation: equation) else { return }
    addLine(tangent, color: color, lineWidth: lineWidth, zPosition: zPosition)
}

public func addSpiral(
    center: Point = Point(x: 0, y: 0),
    a: Double = 0,
    growth: Double = 4,
    turns: Double = 4,
    samplesPerTurn: Int = 120,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    let clampedTurns = max(0, turns)
    let sampleCount = max(2, Int(clampedTurns * Double(max(16, samplesPerTurn))))
    let tMax = 2 * Double.pi * clampedTurns

    plotParametric(
        tMin: 0,
        tMax: tMax,
        samples: sampleCount,
        color: color,
        lineWidth: lineWidth,
        zPosition: zPosition
    ) { t in
        let radius = a + (growth * t)
        let x = center.x + (radius * cos(t))
        let y = center.y + (radius * sin(t))
        return Point(x: x, y: y)
    }
}

public func addCycloid(
    origin: Point = Point(x: 0, y: 0),
    radius: Double = 30,
    cycles: Double = 3,
    samplesPerCycle: Int = 180,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    let safeRadius = max(0.0001, radius)
    let clampedCycles = max(0, cycles)
    let sampleCount = max(2, Int(clampedCycles * Double(max(24, samplesPerCycle))))
    let tMax = 2 * Double.pi * clampedCycles

    plotParametric(
        tMin: 0,
        tMax: tMax,
        samples: sampleCount,
        color: color,
        lineWidth: lineWidth,
        zPosition: zPosition
    ) { t in
        let x = origin.x + safeRadius * (t - sin(t))
        let y = origin.y + safeRadius * (1 - cos(t))
        return Point(x: x, y: y)
    }
}

public func addLissajous(
    center: Point = Point(x: 0, y: 0),
    amplitudeX: Double = 100,
    amplitudeY: Double = 100,
    frequencyX: Double = 3,
    frequencyY: Double = 2,
    phase: Double = 0,
    cycles: Double = 2,
    samplesPerCycle: Int = 220,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    let clampedCycles = max(0, cycles)
    let sampleCount = max(2, Int(clampedCycles * Double(max(24, samplesPerCycle))))
    let tMax = 2 * Double.pi * clampedCycles

    plotParametric(
        tMin: 0,
        tMax: tMax,
        samples: sampleCount,
        color: color,
        lineWidth: lineWidth,
        zPosition: zPosition
    ) { t in
        Point(
            x: center.x + amplitudeX * sin((frequencyX * t) + phase),
            y: center.y + amplitudeY * sin(frequencyY * t)
        )
    }
}

public func addRose(
    center: Point = Point(x: 0, y: 0),
    radius: Double = 120,
    petals: Int = 5,
    cycles: Double = 2,
    samplesPerCycle: Int = 240,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    let k = Double(max(1, petals))
    let clampedCycles = max(0, cycles)
    let sampleCount = max(2, Int(clampedCycles * Double(max(24, samplesPerCycle))))
    let tMax = 2 * Double.pi * clampedCycles

    plotParametric(
        tMin: 0,
        tMax: tMax,
        samples: sampleCount,
        color: color,
        lineWidth: lineWidth,
        zPosition: zPosition
    ) { t in
        let r = radius * cos(k * t)
        return Point(
            x: center.x + r * cos(t),
            y: center.y + r * sin(t)
        )
    }
}

public func addEpicycloid(
    center: Point = Point(x: 0, y: 0),
    fixedRadius: Double = 70,
    rollingRadius: Double = 20,
    cycles: Double = 1,
    samplesPerCycle: Int = 360,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    let R = max(0.0001, fixedRadius)
    let r = max(0.0001, rollingRadius)
    let clampedCycles = max(0, cycles)
    let sampleCount = max(2, Int(clampedCycles * Double(max(48, samplesPerCycle))))
    let tMax = 2 * Double.pi * clampedCycles

    plotParametric(
        tMin: 0,
        tMax: tMax,
        samples: sampleCount,
        color: color,
        lineWidth: lineWidth,
        zPosition: zPosition
    ) { t in
        let x = center.x + (R + r) * cos(t) - r * cos(((R + r) / r) * t)
        let y = center.y + (R + r) * sin(t) - r * sin(((R + r) / r) * t)
        return Point(x: x, y: y)
    }
}

public func addHypocycloid(
    center: Point = Point(x: 0, y: 0),
    fixedRadius: Double = 70,
    rollingRadius: Double = 20,
    cycles: Double = 1,
    samplesPerCycle: Int = 360,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    let R = max(0.0001, fixedRadius)
    let r = max(0.0001, rollingRadius)
    let clampedCycles = max(0, cycles)
    let sampleCount = max(2, Int(clampedCycles * Double(max(48, samplesPerCycle))))
    let tMax = 2 * Double.pi * clampedCycles

    plotParametric(
        tMin: 0,
        tMax: tMax,
        samples: sampleCount,
        color: color,
        lineWidth: lineWidth,
        zPosition: zPosition
    ) { t in
        let x = center.x + (R - r) * cos(t) + r * cos(((R - r) / r) * t)
        let y = center.y + (R - r) * sin(t) - r * sin(((R - r) / r) * t)
        return Point(x: x, y: y)
    }
}

public func addEllipse(
    center: Point = Point(x: 0, y: 0),
    semiMajorAxis a: Double = 120,
    semiMinorAxis b: Double = 80,
    rotationDegrees: Double = 0,
    samples: Int = 360,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    let safeA = max(0.0001, a)
    let safeB = max(0.0001, b)
    let rotation = rotationDegrees * .pi / 180
    let cosR = cos(rotation)
    let sinR = sin(rotation)

    plotParametric(
        tMin: 0,
        tMax: 2 * .pi,
        samples: max(24, samples),
        color: color,
        lineWidth: lineWidth,
        zPosition: zPosition
    ) { t in
        let xLocal = safeA * cos(t)
        let yLocal = safeB * sin(t)
        let x = center.x + (xLocal * cosR - yLocal * sinR)
        let y = center.y + (xLocal * sinR + yLocal * cosR)
        return Point(x: x, y: y)
    }
}

public func addParabola(
    vertex: Point = Point(x: 0, y: 0),
    coefficient: Double = 0.02,
    axis: ParabolaAxis = .vertical,
    domainMin: Double = -150,
    domainMax: Double = 150,
    samples: Int = 300,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    let safeSamples = max(24, samples)
    let minDomain = min(domainMin, domainMax)
    let maxDomain = max(domainMin, domainMax)

    switch axis {
    case .vertical:
        plotFunction(
            xMin: vertex.x + minDomain,
            xMax: vertex.x + maxDomain,
            samples: safeSamples,
            color: color,
            lineWidth: lineWidth,
            zPosition: zPosition
        ) { x in
            let dx = x - vertex.x
            return vertex.y + coefficient * dx * dx
        }

    case .horizontal:
        plotParametric(
            tMin: minDomain,
            tMax: maxDomain,
            samples: safeSamples,
            color: color,
            lineWidth: lineWidth,
            zPosition: zPosition
        ) { t in
            Point(x: vertex.x + coefficient * t * t, y: vertex.y + t)
        }
    }
}

public func addHyperbola(
    center: Point = Point(x: 0, y: 0),
    semiTransverseAxis a: Double = 60,
    semiConjugateAxis b: Double = 30,
    axis: HyperbolaAxis = .horizontal,
    tMin: Double = -2.0,
    tMax: Double = 2.0,
    samples: Int = 320,
    color: UIColor = .systemBlue,
    lineWidth: CGFloat = 2,
    zPosition: Int? = nil
) {
    let safeA = max(0.0001, a)
    let safeB = max(0.0001, b)
    let safeSamples = max(24, samples)
    let minT = min(tMin, tMax)
    let maxT = max(tMin, tMax)
    let split = max(2, safeSamples / 2)

    switch axis {
    case .horizontal:
        plotParametric(
            tMin: minT,
            tMax: maxT,
            samples: split,
            color: color,
            lineWidth: lineWidth,
            zPosition: zPosition
        ) { t in
            Point(
                x: center.x + safeA * cosh(t),
                y: center.y + safeB * sinh(t)
            )
        }

        plotParametric(
            tMin: minT,
            tMax: maxT,
            samples: split,
            color: color,
            lineWidth: lineWidth,
            zPosition: zPosition
        ) { t in
            Point(
                x: center.x - safeA * cosh(t),
                y: center.y + safeB * sinh(t)
            )
        }

    case .vertical:
        plotParametric(
            tMin: minT,
            tMax: maxT,
            samples: split,
            color: color,
            lineWidth: lineWidth,
            zPosition: zPosition
        ) { t in
            Point(
                x: center.x + safeB * sinh(t),
                y: center.y + safeA * cosh(t)
            )
        }

        plotParametric(
            tMin: minT,
            tMax: maxT,
            samples: split,
            color: color,
            lineWidth: lineWidth,
            zPosition: zPosition
        ) { t in
            Point(
                x: center.x + safeB * sinh(t),
                y: center.y - safeA * cosh(t)
            )
        }
    }
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
private var sceneSampleCount = 0
private var sceneObserverInstalled = false
private var hasRegisteredInputIDs: Set<String> = []
private var plotSafetyConfiguration = PlotSafetyConfiguration()

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
    let inputTitle = localizedInputTitle(label ?? inputID)

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
    let inputTitle = localizedInputTitle(label ?? inputID)

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
    let inputTitle = localizedInputTitle(label ?? inputID)

    registerInputIfNeeded(
        id: inputID,
        title: inputTitle,
        kind: "number",
        payloadKey: LiveViewMessageKey.inputNumber,
        payloadValue: .integer(number)
    )

    return currentNumberValue(for: inputID, defaultValue: number)
}

public func Localized(_ key: String) -> String {
    localizedInputTitle(key)
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
    sceneSampleCount = 0
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

private func localizedInputTitle(_ key: String) -> String {
    NSLocalizedString(key, comment: "Input control label")
}

private func sanitizedSampleCount(_ requested: Int, minimum: Int, context: String) -> Int {
    let requestedAtLeastMinimum = max(minimum, requested)
    let maxPerCurve = max(minimum, plotSafetyConfiguration.maxSamplesPerCurve)
    let clamped = min(requestedAtLeastMinimum, maxPerCurve)

    if plotSafetyConfiguration.strictValidation && clamped != requestedAtLeastMinimum {
        assertionFailure("\(context) requested \(requestedAtLeastMinimum) samples, clamped to \(clamped).")
    }

    return clamped
}

private func reserveSceneSampleBudget(_ requested: Int) -> Int {
    guard isRenderingScene else { return requested }

    let maxTotal = max(0, plotSafetyConfiguration.maxTotalSamplesPerScene)
    let remaining = max(0, maxTotal - sceneSampleCount)
    let granted = min(requested, remaining)
    sceneSampleCount += granted

    if plotSafetyConfiguration.strictValidation && granted != requested {
        assertionFailure("Scene sample budget exceeded. Requested \(requested), granted \(granted).")
    }

    return granted
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
