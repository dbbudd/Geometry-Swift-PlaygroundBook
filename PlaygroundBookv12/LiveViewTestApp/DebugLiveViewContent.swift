import UIKit
import BookCore
import BookAPI

struct DebugLiveViewContent {
    @MainActor
    static func render(on liveViewController: LiveViewController) {
        _ = liveViewController

        Scene {
            _ = Input(text: "Recursive Pattern: Fractal Tree", label: "Demo")
            let depthInput = Input(number: 5, label: "Depth (0-8)")
            let trunkLength = Input(decimal: 120, label: "Trunk Length")
            let branchAngle = Input(decimal: 28, label: "Branch Angle")
            let shrinkFactor = Input(decimal: 0.72, label: "Shrink Factor")
            let lineWidth = Input(number: 1, label: "Line Width")

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

            let clampedDepth = max(0, min(8, Int(depthInput)))
            let start = Point(x: 0, y: -180)
            let safeTrunk = max(20.0, trunkLength)
            let safeAngle = max(5.0, min(80.0, branchAngle))
            let safeShrink = max(0.45, min(0.85, shrinkFactor))

            func drawBranch(from start: Point, length: Double, angleDegrees: Double, depth: Int) {
                let radians = angleDegrees * .pi / 180.0
                let end = Point(
                    x: start.x + (length * cos(radians)),
                    y: start.y + (length * sin(radians))
                )

                addLine(
                    Line(start: start, end: end),
                    color: .systemGreen,
                    lineWidth: max(1, lineWidth - CGFloat(max(0, 5 - depth))),
                    zPosition: 2
                )

                if depth == 0 {
                    return
                }

                let nextLength = length * safeShrink
                drawBranch(from: end, length: nextLength, angleDegrees: angleDegrees + safeAngle, depth: depth - 1)
                drawBranch(from: end, length: nextLength, angleDegrees: angleDegrees - safeAngle, depth: depth - 1)
            }

            drawBranch(from: start, length: safeTrunk, angleDegrees: 90, depth: clampedDepth)
            addPoint(start, color: .systemBrown, radius: 4, zPosition: 3)
        }
    }
}
