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
