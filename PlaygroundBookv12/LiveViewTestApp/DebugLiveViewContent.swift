import UIKit
import BookCore
import BookAPI

struct DebugLiveViewContent {
    @MainActor
    static func render(on liveViewController: LiveViewController) {
        _ = liveViewController

        Scene {
            _ = Input(text: "Phase 1 Objects", label: "Demo")
            let lineWidth = Input(number: 3, label: "Line Width")
            let side = Input(decimal: 120, label: "Triangle Side")
            let radius = Input(decimal: 80, label: "Circle Radius")

            let a = Point(x: 100, y: 100)
            let b = Point(x: 20, y: -80)
            let c = Point(x: -80, y: -80 + (sqrt(3) / 2 * side))

            let center = midpoint(a, b)
            let topLine = Line(start: Point(x: -220, y: 140), end: Point(x: 220, y: 140))

            addLine(topLine, color: .systemGray, lineWidth: lineWidth, zPosition: 0)
            addTriangle(
                Triangle(a: a, b: b, c: c),
                color: .systemRed,
                lineWidth: lineWidth,
                zPosition: 1
            )
            addCircle(
                Circle(center: center, radius: radius),
                color: .systemBlue,
                lineWidth: lineWidth,
                zPosition: 2
            )
            addPoint(a, color: .systemGreen, radius: 20, zPosition: 3)
            addPoint(b, color: .systemRed, radius: 5, zPosition: 3)
            addPoint(c, color: .systemGreen, radius: 5, zPosition: 3)

            addPolygon(
                Polygon(vertices: [
                    Point(x: 80, y: -150),
                    Point(x: 220, y: -120),
                    Point(x: 180, y: 0),
                    Point(x: 60, y: -20)
                ]),
                color: .systemPurple,
                lineWidth: lineWidth,
                fillColor: UIColor.systemPurple.withAlphaComponent(0.12),
                zPosition: 1
            )
        }
    }
}
