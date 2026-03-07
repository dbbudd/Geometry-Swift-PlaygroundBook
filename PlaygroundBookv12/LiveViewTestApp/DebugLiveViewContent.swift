import UIKit
import BookCore
import BookAPI

struct DebugLiveViewContent {
    @MainActor
    static func render(on liveViewController: LiveViewController) {
        _ = liveViewController

        animate(duration: 6.0, fps: 30, repeats: true) { t in
            setValidationFeedbackMode(.overlay)
            _ = Input(text: "Animation Demo: Orbit + Rotation", label: "Demo")
            let radius = Input(decimal: 130, label: "Orbit Radius")
            let spin = Input(decimal: 360, label: "Degrees per Cycle")
            let lineWidth = Input(number: 3, label: "Line Width")
            let hatchSpacing = Input(decimal: 10, label: "Hatch Spacing")
            let center = DraggablePoint(
                id: "orbit-center",
                initial: Point(x: 0, y: 0),
                radius: 9,
                color: .systemRed,
                zPosition: 50
            )
            addHint("Drag red handle to move orbit center")

            addLine(
                Line(start: Point(x: -260, y: 0), end: Point(x: 260, y: 0)),
                color: .systemGray,
                lineWidth: lineWidth,
                zPosition: 0
            )
            addLine(
                Line(start: Point(x: 0, y: -220), end: Point(x: 0, y: 220)),
                color: .systemGray,
                lineWidth: lineWidth,
                zPosition: 0
            )

            addCircle(
                Circle(center: center, radius: max(10, radius)),
                color: .systemGray2,
                lineWidth: lineWidth,
                zPosition: 1
            )

            let orbitDegrees = 360.0 * t
            let movingPoint = rotate(
                Point(x: center.x + max(10, radius), y: center.y),
                around: center,
                degrees: orbitDegrees
            )
            addPoint(movingPoint, color: .systemOrange, radius: 5, zPosition: 4)
            let radiusLine = Line(start: center, end: movingPoint)
            addLine(
                radiusLine,
                color: .systemOrange,
                lineWidth: 2,
                zPosition: 3
            )
            addLengthLabel(radiusLine, decimals: 1, color: .systemTeal, zPosition: 9)
            addCoordinateLabel(movingPoint, decimals: 1, color: .systemIndigo, zPosition: 9)
            addAngleMarker(
                vertex: center,
                firstPoint: Point(x: center.x + max(10, radius), y: center.y),
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

            let referenceLine = Line(
                start: Point(x: 120, y: -170),
                end: Point(x: 230, y: -120)
            )
            let parallelLine = parallel(through: Point(x: 170, y: -70), to: referenceLine, length: 170)
            let perpendicularLineSample = perpendicular(through: Point(x: 170, y: -70), to: referenceLine, length: 130)
            let equalLengthLine = equalLength(
                from: Point(x: 50, y: -150),
                reference: Line(start: Point(x: 120, y: -170), end: Point(x: 230, y: -120))
            )

            addLine(referenceLine, color: .systemPink, lineWidth: 2, zPosition: 6)
            addLine(parallelLine, color: .systemMint, lineWidth: 2, zPosition: 6)
            addLine(perpendicularLineSample, color: .systemIndigo, lineWidth: 2, zPosition: 6)
            addLine(equalLengthLine, color: .systemBrown, lineWidth: 2, zPosition: 6)
            addCoordinateLabel(midpoint(referenceLine.start, referenceLine.end), decimals: 0, color: .systemPink, zPosition: 9)

            let segment = Line(start: Point(x: -260, y: 180), end: Point(x: -60, y: 180))
            addLine(segment, color: .systemBlue, lineWidth: 2, zPosition: 6)
            for divisionPoint in divideSegment(segment, into: 5) {
                addPoint(divisionPoint, color: .systemBlue, radius: 3, zPosition: 7)
            }

            if let hex = regularPolygon(center: Point(x: 200, y: 150), sides: 6, radius: 38, rotationDegrees: 30) {
                addPolygon(hex, color: .systemGreen, lineWidth: 2, zPosition: 6)
            }

            let p1 = Point(x: 70, y: -20)
            let p2 = Point(x: 230, y: -10)
            addPoint(p1, color: .systemRed, radius: 4, zPosition: 7)
            addPoint(p2, color: .systemRed, radius: 4, zPosition: 7)
            addLine(Line(start: p1, end: p2), color: .systemRed, lineWidth: 1.5, zPosition: 6)
            addLine(
                locusEquidistant(from: p1, and: p2, length: 220),
                color: .systemPurple,
                lineWidth: 2,
                zPosition: 6
            )
            addCircle(
                locusDistance(from: Point(x: 150, y: -110), radius: 44),
                color: .systemTeal,
                lineWidth: 2,
                zPosition: 6
            )

            let macroSegment = Line(start: Point(x: -40, y: 20), end: Point(x: 40, y: 90))
            let macroBundle = constructPerpendicularBisector(of: macroSegment, length: 220)
            renderConstruction(
                macroBundle,
                pointColor: .systemPink,
                lineColor: .systemBlue,
                circleColor: UIColor.systemTeal.withAlphaComponent(0.5),
                lineWidth: 1.2,
                pointRadius: 2.5,
                zPosition: 5
            )

            let reflectAxis = Line(start: Point(x: -10, y: -170), end: Point(x: 110, y: -80))
            addLine(reflectAxis, color: .systemIndigo, lineWidth: 1.5, zPosition: 6)
            let sourcePoly = Polygon(vertices: [
                Point(x: -40, y: -170),
                Point(x: 0, y: -120),
                Point(x: 45, y: -170)
            ])
            addPolygon(sourcePoly, color: .systemRed, lineWidth: 2, zPosition: 6)
            let reflectedPoly = sourcePoly.transformed(by: reflectionAcross(line: reflectAxis))
            addPolygon(reflectedPoly, color: .systemGreen, lineWidth: 2, zPosition: 6)

            var teachableGroup = makeGroup { group in
                group.addLine(
                    Line(start: Point(x: -40, y: 0), end: Point(x: 40, y: 0)),
                    color: .systemBlue,
                    lineWidth: 2,
                    zPosition: 6
                )
                group.addLine(
                    Line(start: Point(x: 0, y: -40), end: Point(x: 0, y: 40)),
                    color: .systemBlue,
                    lineWidth: 2,
                    zPosition: 6
                )
                group.addCircle(
                    Circle(center: Point(x: 0, y: 0), radius: 22),
                    color: .systemMint,
                    lineWidth: 2,
                    zPosition: 6
                )
            }
            teachableGroup = rotate(group: teachableGroup, around: Point(x: 0, y: 0), degrees: spin * t * 0.5)
            teachableGroup = DraggableGroup(
                id: "group-anchor",
                initialAnchor: Point(x: -210, y: 115),
                group: teachableGroup,
                radius: 8,
                color: .systemPink,
                zPosition: 60
            )
            renderGroup(teachableGroup)

            let style = geometryStyle(.blueprint)
            let cameraCenter = keyframedPoint(
                at: pingPong(t),
                keyframes: [
                    PointKeyframe(time: 0.0, point: Point(x: -30, y: -20)),
                    PointKeyframe(time: 0.5, point: Point(x: 30, y: 20)),
                    PointKeyframe(time: 1.0, point: Point(x: -30, y: -20))
                ],
                curve: .easeInOut
            )
            let cameraZoom = keyframedValue(
                at: pingPong(t),
                keyframes: [
                    ScalarKeyframe(time: 0.0, value: 0.8),
                    ScalarKeyframe(time: 0.5, value: 1.4),
                    ScalarKeyframe(time: 1.0, value: 0.8)
                ],
                curve: .smoothStep
            )

            var cameraDemoGroup = makeGroup { group in
                group.addLine(
                    Line(start: Point(x: -70, y: 0), end: Point(x: 70, y: 0)),
                    color: styleColor(style, role: .guide),
                    lineWidth: style.guideLineWidth,
                    zPosition: 6
                )
                group.addLine(
                    Line(start: Point(x: 0, y: -50), end: Point(x: 0, y: 50)),
                    color: styleColor(style, role: .guide),
                    lineWidth: style.guideLineWidth,
                    zPosition: 6
                )
                group.addTriangle(
                    Triangle(
                        a: Point(x: -36, y: -20),
                        b: Point(x: 38, y: -18),
                        c: Point(x: 2, y: 42)
                    ),
                    color: styleColor(style, role: .primary),
                    lineWidth: style.lineWidth,
                    zPosition: 7
                )
                group.addCircle(
                    Circle(center: Point(x: 2, y: 2), radius: 20),
                    color: styleColor(style, role: .accent),
                    lineWidth: style.lineWidth,
                    zPosition: 7
                )
            }
            cameraDemoGroup = applyCamera(
                to: cameraDemoGroup,
                camera: CameraFrame(center: cameraCenter, zoom: cameraZoom)
            )
            cameraDemoGroup = translate(group: cameraDemoGroup, dx: 210, dy: 130)
            renderGroup(cameraDemoGroup)
        }
    }
}
