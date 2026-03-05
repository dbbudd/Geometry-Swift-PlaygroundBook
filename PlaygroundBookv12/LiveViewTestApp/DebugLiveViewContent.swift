import UIKit
import BookCore
import BookAPI

struct DebugLiveViewContent {
    @MainActor
    static func render(on liveViewController: LiveViewController) {
        _ = liveViewController

        animate(duration: 6.0, fps: 30, repeats: true) { t in
            _ = Input(text: "Animation Demo: Orbit + Rotation", label: "Demo")
            let radius = Input(decimal: 130, label: "Orbit Radius")
            let spin = Input(decimal: 360, label: "Degrees per Cycle")
            let lineWidth = Input(number: 3, label: "Line Width")
            let hatchSpacing = Input(decimal: 10, label: "Hatch Spacing")

            addLine(
                Line(start: Point(x: -260, y: 0), end: Point(x: 260, y: 0)),
                color: .systemGray,
                lineWidth: 1,
                zPosition: 0
            )
            addLine(
                Line(start: Point(x: 0, y: -220), end: Point(x: 0, y: 220)),
                color: .systemGray,
                lineWidth: 1,
                zPosition: 0
            )

            addCircle(
                Circle(center: Point(x: 0, y: 0), radius: max(10, radius)),
                color: .systemGray2,
                lineWidth: 1,
                zPosition: 1
            )

            let orbitDegrees = 360.0 * t
            let movingPoint = rotate(Point(x: max(10, radius), y: 0), degrees: orbitDegrees)
            addPoint(movingPoint, color: .systemOrange, radius: 5, zPosition: 4)
            let radiusLine = Line(start: Point(x: 0, y: 0), end: movingPoint)
            addLine(
                radiusLine,
                color: .systemOrange,
                lineWidth: 2,
                zPosition: 3
            )
            addLengthLabel(radiusLine, decimals: 1, color: .systemTeal, zPosition: 9)
            addCoordinateLabel(movingPoint, decimals: 1, color: .systemIndigo, zPosition: 9)
            addAngleMarker(
                vertex: Point(x: 0, y: 0),
                firstPoint: Point(x: max(10, radius), y: 0),
                secondPoint: movingPoint,
                radius: 26,
                color: .systemPurple,
                lineWidth: 2,
                showLabel: true,
                zPosition: 8
            )

            let baseTriangle = Triangle(
                a: Point(x: 0, y: 28),
                b: Point(x: -24, y: -18),
                c: Point(x: 24, y: -18)
            )
            let rotationTransform = Transform2D.rotation(degrees: spin * t, around: Point(x: 0, y: 0))
            let translationTransform = Transform2D.translation(dx: movingPoint.x, dy: movingPoint.y)
            let animatedTriangle = baseTriangle.transformed(by: rotationTransform.concatenating(translationTransform))
            addTriangle(animatedTriangle, color: .systemBlue, lineWidth: lineWidth, zPosition: 5)

            let shadedRegion = Polygon(vertices: [
                Point(x: -220, y: -170),
                Point(x: -90, y: -170),
                Point(x: -120, y: -70),
                Point(x: -250, y: -90)
            ])
            addFilledPolygon(
                shadedRegion,
                fillColor: UIColor.systemYellow.withAlphaComponent(0.25),
                borderColor: .systemYellow,
                lineWidth: 1.5,
                zPosition: 1
            )
            addHatchedPolygon(
                shadedRegion,
                spacing: max(4, hatchSpacing),
                angleDegrees: 35,
                color: .systemOrange,
                lineWidth: 1,
                zPosition: 2,
                crossHatch: true
            )
        }
    }
}
