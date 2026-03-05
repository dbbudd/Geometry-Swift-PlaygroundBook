import UIKit
import BookCore
import BookAPI

struct DebugLiveViewContent {
    @MainActor
    static func render(on liveViewController: LiveViewController) {
        _ = liveViewController

        Scene {
            var x = Input(text: "...", label: "Text Input:")
            var y = Input(decimal: 100.0, label: "Square Length")
            var z = Input(number: 8, label: "Square Width")
            
            var w = Input(decimal: 100.0, label: "Triangle Length")

            var square = Pen()
            square.penColor = .systemRed
            square.goto(x: 10, y: 10)
            square.lineWidth = z
            square.addLine(distance: y)
            square.turn(degrees: 90)
            square.addLine(distance: y)
            square.turn(degrees: 90)
            square.addLine(distance: y)
            square.turn(degrees: 90)
            square.addLine(distance: y)
            addShape(pen: square)
            
            var triangle = Pen()
            triangle.penColor = .systemGreen
            triangle.lineWidth = z
            
            for i in 0...2{
                triangle.addLine(distance: w)
                triangle.turn(degrees: 120)
            }
            addShape(pen: triangle)
        }
    }
}
