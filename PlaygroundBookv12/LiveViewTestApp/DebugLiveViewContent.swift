import UIKit
import BookCore
import BookAPI

struct DebugLiveViewContent {
    @MainActor
    static func render(on liveViewController: LiveViewController) {
        _ = liveViewController

        Scene {
            _ = Input(text: "Phase 3 Core Geometry", label: "Demo")
            let lineWidth = Input(number: 2, label: "Line Width")
            let baseWidth = Input(decimal: 220, label: "Base Width")
            let apexHeight = Input(decimal: 170, label: "Apex Height")

            let triangle = Triangle(
                a: Point(x: 0, y: apexHeight),
                b: Point(x: -baseWidth / 2, y: -100),
                c: Point(x: baseWidth / 2, y: -100)
            )

            addTriangle(triangle, color: .systemBlue, lineWidth: lineWidth, zPosition: 2)

            let baseLine = Line(start: triangle.b, end: triangle.c)
            let baseBisector = perpendicularBisector(of: baseLine, length: 500)
            addLine(baseBisector, color: .systemGray, lineWidth: 1, zPosition: 0)

            if let bisectorA = angleBisector(at: triangle.a, through: triangle.b, and: triangle.c, length: 500) {
                addLine(bisectorA, color: .systemOrange, lineWidth: 1, zPosition: 1)
            }

            let g = centroid(triangle)
            addPoint(g, color: .systemGreen, radius: 5, zPosition: 5)

            if let i = incenter(triangle) {
                addPoint(i, color: .systemOrange, radius: 5, zPosition: 5)
            }

            if let o = circumcenter(triangle) {
                addPoint(o, color: .systemPurple, radius: 5, zPosition: 5)
                addCircle(
                    Circle(center: o, radius: distance(o, triangle.a)),
                    color: .systemPurple,
                    lineWidth: 1,
                    zPosition: 0
                )
            }

            if let h = orthocenter(triangle) {
                addPoint(h, color: .systemRed, radius: 5, zPosition: 5)
            }
        }
    }
}
