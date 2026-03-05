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
