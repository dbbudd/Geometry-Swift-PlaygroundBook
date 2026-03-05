import UIKit
import BookCore
import BookAPI

struct DebugLiveViewContent {
    @MainActor
    static func render(on liveViewController: LiveViewController) {
        _ = liveViewController

        Scene {
            _ = Input(text: "Phase 1C Transforms", label: "Demo")
            let lineWidth = Input(number: 3, label: "Line Width")
            let angle = Input(decimal: 25, label: "Rotate Degrees")
            let factor = Input(decimal: 1.2, label: "Scale Factor")

            let baseTriangle = Triangle(
                a: Point(x: 0, y: 0),
                b: Point(x: 120, y: 0),
                c: Point(x: 60, y: 104)
            )
            let pivot = Point(x: 0, y: 0)
            let transform = Transform2D.identity
                .concatenating(.rotation(degrees: angle, around: pivot))
                .concatenating(.scaling(factor: factor, around: pivot))
            let transformedTriangle = baseTriangle.transformed(by: transform)

            let baseCircle = Circle(center: Point(x: 110, y: 60), radius: 35)
            let reflectedCircle = baseCircle.transformed(by: .reflectionAcrossY())
            let movedCircle = baseCircle.transformed(by: .translation(dx: -40, dy: -120))

            addTriangle(
                baseTriangle,
                color: .systemRed,
                lineWidth: lineWidth,
                zPosition: 1
            )
            addTriangle(
                transformedTriangle,
                color: .systemBlue,
                lineWidth: lineWidth,
                zPosition: 2
            )

            addCircle(
                baseCircle,
                color: .systemRed,
                lineWidth: lineWidth,
                zPosition: 1
            )
            addCircle(
                movedCircle,
                color: .systemOrange,
                lineWidth: lineWidth,
                zPosition: 2
            )
            addCircle(
                reflectedCircle,
                color: .systemPink,
                lineWidth: lineWidth,
                zPosition: 3
            )

            let m = midpoint(baseTriangle.a, baseTriangle.b)
            addPoint(m, color: .systemGreen, radius: 4, zPosition: 6)

            let base = Line(start: baseTriangle.a, end: baseTriangle.b)
            _ = slope(base.start, base.end)
            _ = distance(base.start, base.end)
        }
    }
}
