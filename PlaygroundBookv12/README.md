# Geometry Playground Book

## Overview

This project builds a Swift Playground Book focused on interactive geometry learning.

The runtime has three core goals:
- Render a Cartesian plane with a predictable scale.
- Let learners draw using a simple `Pen` API.
- Let learners adjust variables live with `Input(...)` controls and immediately redraw.

The Xcode project produces:
- `Geometry.playgroundbook` (the distributable book)
- `LiveViewTestApp.app` (fast local live-view debugging)

## Project Layout

- `PlaygroundBook/`
- `Modules/BookCore.playgroundmodule/Sources/` author-only rendering/runtime code
- `Modules/BookAPI.playgroundmodule/Sources/` learner-facing API (`Pen`, `Input`, `Scene`, `addShape`)
- `Chapters/.../Pages/.../main.swift` learner page code
- `PrivateResources/` book-level resources (including `cover.png`)

Build/config files:
- `ConfigFiles/BuildSettings.xcconfig` contains editable product metadata and output naming.

## Runtime Architecture

### BookCore

`BookCore` owns rendering and live-view plumbing:
- `LiveViewController`: receives messages from page/API code and updates model state.
- `CartesianPlaneView`: SwiftUI view that draws grid, axes, labels, shape paths, and input panel.
- `LiveViewInputStore`: shared input state + observers used for reactive rerender.
- `LiveViewSupport`: live-view instantiation for Playground and debug app.

### BookAPI

`BookAPI` exposes learner-facing functions and types:
- `Pen`
- `addShape(pen:)`
- `Input(...)`
- `Scene { ... }`

`Scene` automatically reruns when registered inputs change.

## Grid & Plane Rendering

The Cartesian plane is drawn in `CartesianPlaneView` using SwiftUI `Canvas`:
- Minor grid spacing: 10 px (`minorGridSpacing`)
- Major step: every 5 minor cells (`majorGridStep`)
- Axis origin: center of view (`size.width/2`, `size.height/2`)
- Shape drawing applies a transform so `(0,0)` is center and positive Y points upward.

Tick labels are generated from spacing/step values so labels match pixel scale.

## Pen API

`Pen` is a lightweight command recorder.

Common properties:
- `penColor: UIColor`
- `fillColor: UIColor`
- `lineWidth: CGFloat`
- `zPosition: Int?` optional explicit layer ordering

Common methods:
- `addLine(distance:)`
- `move(distance:)`
- `goto(x:y:)`
- `goto(dx:dy:)`
- `drawTo(dx:dy:)`
- `turn(degrees:)`
- `drawCircle(radius:)`
- `addArc(radius:angle:)`

Layering:
- If `zPosition` is set, it is used for draw order.
- Otherwise, creation order is used.

## Input API

`Input` registers controls in the live-view controls panel and returns typed values:
- `Input(text:label:) -> String`
- `Input(decimal:label:) -> Double`
- `Input(number:label:) -> CGFloat`

Notes:
- Keep `label` values unique; labels are currently used as stable input keys.
- Numeric controls support both typed entry and stepper nudge (+/- 1).
- The controls panel can be minimized; minimized state shows a gear icon to reopen.

## Reactive Drawing (`Scene`)

Use `Scene { ... }` to make drawing reactive to control changes:

```swift
Scene {
    let side = Input(decimal: 120, label: "Square Length")
    let width = Input(number: 4, label: "Line Width")

    var square = Pen()
    square.penColor = .systemRed
    square.lineWidth = width

    for _ in 0...3 {
        square.addLine(distance: side)
        square.turn(degrees: 90)
    }

    addShape(pen: square)
}
```

No manual redraw callback is required.

## Phase 1 Geometry Objects Example

```swift
Scene {
    _ = Input(text: "Phase 1 Objects", label: "Demo")
    let lineWidth = Input(number: 3, label: "Line Width")
    let side = Input(decimal: 120, label: "Triangle Side")
    let radius = Input(decimal: 80, label: "Circle Radius")

    let a = Point(x: -180, y: -80)
    let b = Point(x: 20, y: -80)
    let c = Point(x: -80, y: -80 + (sqrt(3) / 2 * side))

    let center = midpoint(a, b)
    let topLine = Line(start: Point(x: -220, y: 140), end: Point(x: 220, y: 140))

    addLine(topLine, color: .systemGray, lineWidth: lineWidth, zPosition: 0)
    addTriangle(Triangle(a: a, b: b, c: c), color: .systemRed, lineWidth: lineWidth, zPosition: 1)
    addCircle(Circle(center: center, radius: radius), color: .systemBlue, lineWidth: lineWidth, zPosition: 2)
    addPoint(a, color: .systemGreen, radius: 5, zPosition: 3)
    addPoint(b, color: .systemGreen, radius: 5, zPosition: 3)
    addPoint(c, color: .systemGreen, radius: 5, zPosition: 3)
}
```

## Phase 1C Transform Helpers

Phase 1C adds direct transform helpers for each geometry type, plus a composable `Transform2D`.
- `translate(..., dx:dy:)`
- `rotate(..., around:degrees:)`
- `scale(..., around:factor:)`

These work with:
- `Point`
- `Line`
- `Circle`
- `Triangle`
- `Polygon`

`Transform2D` supports:
- `Transform2D.identity`
- `.translation(dx:dy:)`
- `.rotation(degrees:around:)`
- `.scaling(factor:around:)`
- `.reflectionAcrossX()`
- `.reflectionAcrossY()`
- composition via `.concatenating(...)`
- per-type `.transformed(by:)`

```swift
Scene {
    let angle = Input(decimal: 25, label: "Rotate Degrees")
    let factor = Input(decimal: 1.2, label: "Scale Factor")
    let shiftX = Input(decimal: 140, label: "Translate X")

    let base = Triangle(
        a: Point(x: -120, y: -80),
        b: Point(x: 0, y: -80),
        c: Point(x: -60, y: 24)
    )

    let pivot = Point(x: -60, y: -30)
    let transform = Transform2D.identity
        .concatenating(.translation(dx: shiftX, dy: 0))
        .concatenating(.rotation(degrees: angle, around: pivot))
        .concatenating(.scaling(factor: factor, around: pivot))

    addTriangle(base, color: .systemRed, zPosition: 1)
    addTriangle(base.transformed(by: transform), color: .systemBlue, zPosition: 2)
}
```

## Phase 3 Core Geometry (Centers + Constructions)

Phase 3 introduces:
- triangle centers: `centroid`, `incenter`, `circumcenter`, `orthocenter`
- intersections: `intersection(_:_:)`
- construction helpers: `perpendicularBisector(of:)`, `perpendicularLine(through:to:)`, `angleBisector(at:through:and:)`

```swift
Scene {
    let lineWidth = Input(number: 2, label: "Line Width")
    let baseWidth = Input(decimal: 220, label: "Base Width")
    let apexHeight = Input(decimal: 170, label: "Apex Height")

    let triangle = Triangle(
        a: Point(x: 0, y: apexHeight),
        b: Point(x: -baseWidth / 2, y: -100),
        c: Point(x: baseWidth / 2, y: -100)
    )

    addTriangle(triangle, color: .systemBlue, lineWidth: lineWidth, zPosition: 2)
    addLine(perpendicularBisector(of: Line(start: triangle.b, end: triangle.c), length: 500), color: .systemGray, lineWidth: 1, zPosition: 0)

    let g = centroid(triangle)
    addPoint(g, color: .systemGreen, radius: 5, zPosition: 5)
    if let i = incenter(triangle) { addPoint(i, color: .systemOrange, radius: 5, zPosition: 5) }
    if let o = circumcenter(triangle) {
        addPoint(o, color: .systemPurple, radius: 5, zPosition: 5)
        addCircle(Circle(center: o, radius: distance(o, triangle.a)), color: .systemPurple, lineWidth: 1, zPosition: 0)
    }
    if let h = orthocenter(triangle) { addPoint(h, color: .systemRed, radius: 5, zPosition: 5) }
}
```

## Phase 4 Curves and Plotting

Phase 4 adds numeric plotting helpers:
- `plotParametric(...)`
- `plotFunction(...)`
- `addSpiral(...)`
- `addCycloid(...)`
- `addLissajous(...)`
- `addRose(...)`
- `addEpicycloid(...)`
- `addHypocycloid(...)`
- `addEllipse(...)`
- `addParabola(...)`
- `addHyperbola(...)`

```swift
Scene {
    let lineWidth = Input(number: 2, label: "Line Width")
    let spiralTurns = Input(decimal: 3.5, label: "Spiral Turns")
    let spiralGrowth = Input(decimal: 2.0, label: "Spiral Growth")
    let cycloidRadius = Input(decimal: 20.0, label: "Cycloid Radius")

    plotFunction(
        xMin: -150,
        xMax: 150,
        samples: 400,
        color: .systemBlue,
        lineWidth: lineWidth
    ) { x in
        40 * sin(x / 30)
    }

    plotParametric(
        tMin: 0,
        tMax: 2 * .pi,
        samples: 220,
        color: .systemGreen,
        lineWidth: lineWidth
    ) { t in
        Point(x: 80 * cos(3 * t), y: 80 * sin(2 * t))
    }

    addSpiral(
        center: Point(x: -140, y: -90),
        growth: spiralGrowth,
        turns: spiralTurns,
        color: .systemPurple,
        lineWidth: lineWidth
    )

    addCycloid(
        origin: Point(x: -120, y: 20),
        radius: cycloidRadius,
        cycles: 2.6,
        color: .systemOrange,
        lineWidth: lineWidth
    )

    addRose(center: Point(x: 150, y: -110), radius: 75, petals: 5, color: .systemPink, lineWidth: lineWidth)
    addLissajous(center: Point(x: 130, y: 110), amplitudeX: 90, amplitudeY: 60, frequencyX: 3, frequencyY: 2, phase: 0.6, color: .systemIndigo, lineWidth: lineWidth)
}
```

Conics example:

```swift
Scene {
    let lineWidth = Input(number: 2, label: "Line Width")
    let ellipseA = Input(decimal: 110, label: "Ellipse a")
    let ellipseB = Input(decimal: 60, label: "Ellipse b")
    let parabolaK = Input(decimal: 0.012, label: "Parabola k")
    let hyperbolaA = Input(decimal: 55, label: "Hyperbola a")
    let hyperbolaB = Input(decimal: 32, label: "Hyperbola b")

    addEllipse(center: Point(x: -120, y: 90), semiMajorAxis: ellipseA, semiMinorAxis: ellipseB, rotationDegrees: 25, color: .systemPurple, lineWidth: lineWidth)
    addParabola(vertex: Point(x: 120, y: -100), coefficient: parabolaK, axis: .vertical, domainMin: -180, domainMax: 180, color: .systemOrange, lineWidth: lineWidth)
    addHyperbola(center: Point(x: -20, y: -20), semiTransverseAxis: hyperbolaA, semiConjugateAxis: hyperbolaB, axis: .horizontal, tMin: -1.8, tMax: 1.8, color: .systemBlue, lineWidth: lineWidth)
}
```

## Phase 4D Teaching Helpers

Phase 4D adds classroom-oriented helper APIs:
- `sampleFunction(...)`
- `sampleParametric(...)`
- `addSamplePoints(...)`
- `tangentLineToFunction(...)` / `addTangentToFunction(...)`
- `tangentLineToParametric(...)` / `addTangentToParametric(...)`

```swift
Scene {
    let lineWidth = Input(number: 2, label: "Line Width")
    let tangentX = Input(decimal: 30, label: "Tangent X")
    let sampleStride = Input(number: 20, label: "Sample Every N")

    let functionCurve: (Double) -> Double? = { x in
        55 * sin(x / 35)
    }

    plotFunction(xMin: -220, xMax: 220, samples: 480, color: .systemBlue, lineWidth: lineWidth, function: functionCurve)
    let sampled = sampleFunction(xMin: -220, xMax: 220, samples: 220, function: functionCurve)
    addSamplePoints(sampled, every: max(1, Int(sampleStride)), color: .systemTeal, radius: 2.5)
    addTangentToFunction(atX: tangentX, length: 170, color: .systemOrange, lineWidth: lineWidth, function: functionCurve)
}
```

## Phase 5A Safety + Localization

Phase 5A introduces runtime guardrails for plotting-heavy lessons:
- `PlotSafetyConfiguration`
- `setPlotSafetyConfiguration(...)`
- `currentPlotSafetyConfiguration()`

Defaults:
- `maxSamplesPerCurve = 4000`
- `maxTotalSamplesPerScene = 30000`
- `strictValidation = false`

Behavior:
- `plotParametric(...)` and `sampleParametric(...)` now normalize domains, clamp sample counts, and enforce a per-scene sample budget during `Scene` rendering.
- Non-finite domain values are ignored safely (no draw) to avoid crashes from invalid math input.
- Strict mode optionally triggers assertion failures in debug runs when requests exceed configured limits.

Localization support:
- `Input(..., label:)` now resolves labels through `NSLocalizedString`.
- `Localized(_ key: String)` is available for explicit localized text usage in learner code.
- This lets you localize control labels via standard `.strings` resources without changing API surface.

## Phase 6A Animation API

Phase 6A introduces a timer-driven animation loop that redraws the scene each frame:
- `animate(duration:fps:repeats:_:)`
- `stopAnimation()`

Behavior:
- The animation closure receives normalized time `t` in the range `0...1`.
- `repeats: true` loops continuously.
- `repeats: false` plays once and automatically stops at the end.
- Calling `Scene { ... }` stops any active animation to avoid mixed render modes.

```swift
animate(duration: 6.0, fps: 30, repeats: true) { t in
    let radius = Input(decimal: 130, label: "Orbit Radius")
    let spin = Input(decimal: 360, label: "Degrees per Cycle")
    let lineWidth = Input(number: 3, label: "Line Width")

    let orbitDegrees = 360.0 * t
    let movingPoint = rotate(Point(x: radius, y: 0), degrees: orbitDegrees)

    addCircle(Circle(center: Point(x: 0, y: 0), radius: radius), color: .systemGray2, lineWidth: 1)
    addLine(Line(start: Point(x: 0, y: 0), end: movingPoint), color: .systemOrange, lineWidth: 2)
    addPoint(movingPoint, color: .systemOrange, radius: 5)

    let baseTriangle = Triangle(
        a: Point(x: 0, y: 28),
        b: Point(x: -24, y: -18),
        c: Point(x: 24, y: -18)
    )
    let transform = Transform2D
        .rotation(degrees: spin * t, around: Point(x: 0, y: 0))
        .concatenating(.translation(dx: movingPoint.x, dy: movingPoint.y))
    addTriangle(baseTriangle.transformed(by: transform), color: .systemBlue, lineWidth: lineWidth)
}
```

## Phase 6B Measurement Overlays

Phase 6B adds classroom-friendly visual annotations:
- `addCoordinateLabel(_:)`
- `addLengthLabel(_:)`
- `addAngleMarker(...)`

These overlays are rendered in Cartesian coordinates and stay synchronized with animated geometry.

```swift
let a = Point(x: 0, y: 0)
let b = Point(x: 120, y: 80)
let line = Line(start: a, end: b)

addLine(line, color: .systemOrange, lineWidth: 2)
addCoordinateLabel(b, decimals: 1, color: .systemIndigo)
addLengthLabel(line, decimals: 1, color: .systemTeal)
addAngleMarker(
    vertex: a,
    firstPoint: Point(x: 120, y: 0),
    secondPoint: b,
    radius: 28,
    color: .systemPurple,
    showLabel: true
)
```

## Phase 6C Teacher View Toggles

Phase 6C adds API controls for classroom display modes:
- `setGridVisible(_:)`
- `setAxesVisible(_:)`
- `setLabelsVisible(_:)`
- `setControlsVisible(_:)`

Use these in `Scene` or `animate` blocks to simplify the visual output for specific lessons.

UI workflow:
- A dedicated Preferences icon (`slider.horizontal.3`) appears in the LiveView.
- When controls are minimized, both the gear icon (Controls) and slider icon (Preferences) are available.
- Preferences contains live switches for Grid, Axes, and Labels.
- These switches now remain responsive even while `animate(...)` is running (unless code explicitly overrides visibility in-frame).

```swift
let showGrid = Input(number: 1, label: "Show Grid 0/1")
let showAxes = Input(number: 1, label: "Show Axes 0/1")
let showLabels = Input(number: 1, label: "Show Labels 0/1")

setGridVisible(showGrid >= 1)
setAxesVisible(showAxes >= 1)
setLabelsVisible(showLabels >= 1)
setControlsVisible(true)
```

## Phase 6D Fill and Shading

Phase 6D adds region-style rendering helpers for area and composite-shape lessons:
- `addFilledPolygon(...)`
- `addFilledTriangle(...)`
- `addFilledCircle(...)`
- `addHatchedPolygon(..., crossHatch:)`

`addHatchedPolygon` clips hatch lines to polygon boundaries and supports optional cross-hatching.
These APIs can be combined with static or animated geometry, depending on lesson goals.

```swift
let region = Polygon(vertices: [
    Point(x: -160, y: -120),
    Point(x: -40, y: -120),
    Point(x: -70, y: -40),
    Point(x: -190, y: -60)
])

addFilledPolygon(
    region,
    fillColor: UIColor.systemYellow.withAlphaComponent(0.25),
    borderColor: .systemYellow,
    lineWidth: 1.5
)

addHatchedPolygon(
    region,
    spacing: 10,
    angleDegrees: 35,
    color: .systemOrange,
    lineWidth: 1,
    crossHatch: true
)
```

## Phase 7A Constraint Helpers

Phase 7A adds construction helpers for congruency and similarity demonstrations:
- `parallel(through:to:length:)`
- `perpendicular(through:to:length:)`
- `equalLength(from:reference:)`

Notes:
- `parallel` and `perpendicular` return centered construction lines through the specified point.
- `equalLength` returns a line starting at `from` with the same length and direction as the reference line.

```swift
let reference = Line(start: Point(x: -80, y: -40), end: Point(x: 40, y: 20))
let p = Point(x: 100, y: 60)

let pLine = parallel(through: p, to: reference, length: 180)
let nLine = perpendicular(through: p, to: reference, length: 140)
let sameLength = equalLength(from: Point(x: -180, y: -120), reference: reference)

addLine(reference, color: .systemPink, lineWidth: 2)
addLine(pLine, color: .systemMint, lineWidth: 2)
addLine(nLine, color: .systemIndigo, lineWidth: 2)
addLine(sameLength, color: .systemBrown, lineWidth: 2)
```

## Phase 7B Draggable Points (Interactive Geometry)

Phase 7B adds direct manipulation points in the live view:
- `DraggablePoint(id:initial:radius:color:zPosition:enabled:)`
- `setHandlesVisible(_:)`
- `setHandlesLocked(_:)`
- `setHandleAppearance(radius:color:)`
- `setHandleSnapMode(_:gridSpacing:)`

Behavior:
- Draggable points are opt-in (only points declared with `DraggablePoint(...)` are interactive).
- A global Preferences toggle controls handle visibility and lock state.
- Drag updates feed back into scene state so `Scene`/`animate` rerenders use current point positions.
- Snap modes: `.none`, `.grid`, `.xAxis`, `.yAxis`, `.axes`.

```swift
animate(duration: 6, fps: 30, repeats: true) { t in
    let center = DraggablePoint(
        id: "orbit-center",
        initial: Point(x: 0, y: 0),
        radius: 9,
        color: .systemRed
    )

    setHandlesVisible(true)
    setHandlesLocked(false)

    let r = Input(decimal: 130, label: "Orbit Radius")
    let moving = rotate(Point(x: center.x + r, y: center.y), around: center, degrees: 360 * t)
    addCircle(Circle(center: center, radius: r), color: .systemGray2, lineWidth: 1)
    addLine(Line(start: center, end: moving), color: .systemOrange, lineWidth: 2)
}
```

## Phase 7C Trace and Playback (MVP)

Phase 7C adds a built-in trace timeline in LiveView for step-by-step replay.

What it does:
- Captures frame snapshots (pens, measurements, draggable points) while scenes render.
- Provides playback controls in the UI: back, play/pause, forward, reset, clear.
- Supports deterministic step navigation for construction walkthroughs.

API helpers:
- `setTraceControlsVisible(_:)`
- `setTraceCaptureEnabled(_:)`
- `setTraceCaptureMode(_:)` (`.allFrames` or `.changedOnly`)
- `setTracePlaybackSpeed(_:)`

Notes:
- Capture is bounded (`maxTraceFrames = 600`) to avoid unbounded growth.
- During active playback, incoming render updates are ignored until playback is paused/reset.
- Trace capture is off by default; enabling capture also reveals the trace controls panel.
- Playback supports speed presets in the trace panel.
- Change-only capture mode avoids storing duplicate consecutive frames.

## Phase 8C Segment and Polygon Utilities

Phase 8 starts with low-risk utility helpers:
- `point(on:t:)`
- `divideSegment(_:into:)`
- `regularPolygon(center:sides:radius:rotationDegrees:)`

```swift
let segment = Line(start: Point(x: -220, y: 140), end: Point(x: -40, y: 140))
addLine(segment, color: .systemBlue, lineWidth: 2)

for p in divideSegment(segment, into: 6) {
    addPoint(p, color: .systemBlue, radius: 3)
}

let quarter = point(on: segment, t: 0.25)
addCoordinateLabel(quarter, decimals: 1, color: .systemIndigo)

if let pentagon = regularPolygon(center: Point(x: 150, y: 110), sides: 5, radius: 42, rotationDegrees: 18) {
    addPolygon(pentagon, color: .systemGreen, lineWidth: 2)
}
```

## Phase 8A Loci Helpers

Phase 8A adds locus-focused helpers for construction lessons:
- `locusEquidistant(from:and:length:)`
- `locusDistance(from:radius:)`
- `locusEquidistant(fromLine:andLine:length:)`

```swift
let a = Point(x: -120, y: -40)
let b = Point(x: 40, y: 20)
addLine(Line(start: a, end: b), color: .systemRed, lineWidth: 1.5)
addLine(locusEquidistant(from: a, and: b, length: 260), color: .systemPurple, lineWidth: 2)

let center = Point(x: 150, y: -90)
addCircle(locusDistance(from: center, radius: 46), color: .systemTeal, lineWidth: 2)

let l1 = Line(start: Point(x: -220, y: 40), end: Point(x: -40, y: 110))
let l2 = Line(start: Point(x: -210, y: -40), end: Point(x: -10, y: 20))
if let bisector = locusEquidistant(fromLine: l1, andLine: l2, length: 320) {
    addLine(bisector, color: .systemIndigo, lineWidth: 2)
}
```

## Phase 8B Compass/Straightedge Macros

Phase 8B introduces reusable construction macros that return full guide geometry:
- `constructPerpendicularBisector(of:length:)`
- `constructAngleBisector(vertex:firstPoint:secondPoint:length:)`
- `constructPerpendicularThroughPoint(point:to:length:)`
- `constructParallelThroughPoint(point:to:length:)`
- `renderConstruction(_:)`

Each macro returns `ConstructionBundle` with:
- `guidePoints`
- `guideLines`
- `guideCircles`

```swift
let segment = Line(start: Point(x: -80, y: 10), end: Point(x: 40, y: 90))
let construction = constructPerpendicularBisector(of: segment, length: 280)

renderConstruction(
    construction,
    pointColor: .systemPink,
    lineColor: .systemBlue,
    circleColor: UIColor.systemTeal.withAlphaComponent(0.5),
    lineWidth: 1.2,
    pointRadius: 2.5
)
```

## Phase 8D Transform Investigations

Phase 8D adds transform helpers for advanced investigations:
- `reflectionAcross(line:)`
- `composeTransforms(_:)`

```swift
let axis = Line(start: Point(x: -20, y: -120), end: Point(x: 110, y: -40))
let source = Polygon(vertices: [
    Point(x: -50, y: -140),
    Point(x: 0, y: -90),
    Point(x: 40, y: -140)
])

let reflected = source.transformed(by: reflectionAcross(line: axis))
addLine(axis, color: .systemIndigo, lineWidth: 1.5)
addPolygon(source, color: .systemRed, lineWidth: 2)
addPolygon(reflected, color: .systemGreen, lineWidth: 2)

let composed = composeTransforms([
    .translation(dx: 80, dy: 20),
    .rotation(degrees: 25, around: Point(x: 80, y: 20)),
    .scaling(factor: 1.2, around: Point(x: 80, y: 20))
])
addPolygon(source.transformed(by: composed), color: .systemOrange, lineWidth: 2)
```

## Phase 8E Validation and Teaching UX

Phase 8E adds lightweight feedback and hint overlays:
- `setValidationFeedbackMode(_:)` (`.none` or `.overlay`)
- `addHint(_:at:color:fontSize:zPosition:)`

Validation overlays are now emitted for common invalid constructions, including:
- `divideSegment(_:into:)` with `parts < 1`
- `regularPolygon(...)` invalid side/radius parameters
- `constructAngleBisector(...)` degenerate angle inputs
- `reflectionAcross(line:)` with a degenerate axis

```swift
setValidationFeedbackMode(.overlay)
addHint("Try dragging the construction points")
```

## Phase 9A Grouping and Group Transforms

Phase 9A introduces a lightweight grouping layer in `BookAPI` for composing and transforming related geometry together.

New types:
- `GeometryGroup`
- `GroupLine`
- `GroupCircle`
- `GroupTriangle`
- `GroupPolygon`

New helpers:
- `makeGroup(_:)`
- `mergeGroups(_:)`
- `renderGroup(_:)`
- `translate(group:dx:dy:)`
- `rotate(group:around:degrees:)`
- `scale(group:around:factor:)`
- `GroupAnchor(...)` (draggable anchor point via existing draggable-handle system)

```swift
let anchor = GroupAnchor(id: "demo-group", initial: Point(x: -180, y: 120))

var group = makeGroup { g in
    g.addLine(Line(start: Point(x: -40, y: 0), end: Point(x: 40, y: 0)), color: .systemBlue)
    g.addLine(Line(start: Point(x: 0, y: -40), end: Point(x: 0, y: 40)), color: .systemBlue)
    g.addCircle(Circle(center: Point(x: 0, y: 0), radius: 22), color: .systemMint)
}

group = rotate(group: group, around: Point(x: 0, y: 0), degrees: 30)
group = translate(group: group, dx: anchor.x, dy: anchor.y)
renderGroup(group)
```

## Phase 9B Draggable Groups

Phase 9B adds a direct group-level drag helper:
- `DraggableGroup(id:initialAnchor:group:radius:color:zPosition:enabled:) -> GeometryGroup`

This binds one draggable handle to the entire group and returns the translated group for rendering.

Additional aliases:
- `setGroupHandlesVisible(_:)`
- `setGroupHandlesLocked(_:)`

```swift
var group = makeGroup { g in
    g.addTriangle(
        Triangle(
            a: Point(x: -40, y: -20),
            b: Point(x: 40, y: -20),
            c: Point(x: 0, y: 40)
        ),
        color: .systemBlue
    )
}

group = DraggableGroup(
    id: "triangle-group",
    initialAnchor: Point(x: -180, y: 120),
    group: group,
    radius: 8,
    color: .systemPink
)

renderGroup(group)
```

## Phase 9C Timeline and Choreography Helpers

Phase 9C adds reusable timing primitives for animation sequencing:
- `EasingCurve` (`.linear`, `.easeIn`, `.easeOut`, `.easeInOut`, `.smoothStep`)
- `timelineProgress(_:start:end:curve:)`
- `pingPong(_:)`
- `keyframedValue(at:keyframes:curve:)`
- `keyframedPoint(at:keyframes:curve:)`

```swift
let p = timelineProgress(t, start: 0.2, end: 0.8, curve: .easeInOut)
let x = keyframedValue(
    at: pingPong(t),
    keyframes: [
        ScalarKeyframe(time: 0.0, value: -80),
        ScalarKeyframe(time: 0.5, value: 80),
        ScalarKeyframe(time: 1.0, value: -80)
    ],
    curve: .smoothStep
)
```

## Phase 9D Style Presets

Phase 9D adds style presets for consistent visual language across lessons:
- `GeometryStylePresetName` (`.classic`, `.blueprint`, `.chalkboard`, `.sunset`)
- `geometryStyle(_:)`
- `styleColor(_:role:)`
- styled draw helpers:
  - `addStyledLine`
  - `addStyledCircle`
  - `addStyledTriangle`
  - `addStyledPolygon`
  - `addStyledPoint`

```swift
let style = geometryStyle(.blueprint)
addStyledLine(Line(start: Point(x: -120, y: 0), end: Point(x: 120, y: 0)), style: style, role: .guide)
addStyledPoint(Point(x: 0, y: 0), style: style, role: .accent)
```

## Phase 9E Camera and Framing Utilities

Phase 9E adds camera/framing helpers for composing scenes and mini-views:
- `Bounds2D`
- `CameraFrame`
- `bounds(of:)` for points/line/circle/triangle/polygon/group
- `mergeBounds(_:)`
- `fitCamera(to:viewportSize:padding:)`
- `cameraTransform(_:)`
- `applyCamera(to:camera:)` for point/line/circle/triangle/polygon/group

```swift
if let b = bounds(of: group) {
    let camera = fitCamera(to: b, viewportSize: CGSize(width: 260, height: 180), padding: 20)
    let framed = applyCamera(to: group, camera: camera)
    renderGroup(translate(group: framed, dx: 180, dy: 100))
}
```

## LiveView Testing Workflow

Use `LiveViewTestApp` for fast iteration:
- Configure scene in `LiveViewTestApp/DebugLiveViewContent.swift`.
- Run `LiveViewTestApp` target for quick visual testing.
- Build `PlaygroundBook` target to produce the distributable `.playgroundbook`.

## Cover Image

Book cover setup:
- Place image in `PlaygroundBook/PrivateResources/` (e.g. `cover.png`).
- Reference it from `PlaygroundBook/Manifest.plist` via:

```xml
<key>ImageReference</key>
<string>cover.png</string>
```

## Output Name & Metadata

Set in `ConfigFiles/BuildSettings.xcconfig`:
- `PLAYGROUND_BOOK_FILE_NAME = Geometry`
- `PLAYGROUND_BOOK_CONTENT_IDENTIFIER`
- `PLAYGROUND_BOOK_CONTENT_VERSION`

These settings control final product naming and manifest metadata.

## Authoring Notes for Forks

When forking/extending this template:
- Keep module source files inside `*.playgroundmodule/Sources/`.
- Keep learner-facing APIs in `BookAPI`; keep implementation/runtime in `BookCore`.
- Add any new resources to the PlaygroundBook target’s `Copy Bundle Resources` phase.
- Keep `main.swift` learner-friendly; use hidden-code regions for scaffolding if needed.
- Use stable input keys/labels for deterministic reactive behavior.

## Known Design Choices

- Controls are currently keyed by `label` for simplicity.
- `Input(number:)` returns `CGFloat` for ergonomic assignment to properties like `lineWidth`.
- Live-view storyboard loading falls back to programmatic controller creation when storyboard resources are absent in debug builds.

## License

See `LICENSE/LICENSE.txt`.
