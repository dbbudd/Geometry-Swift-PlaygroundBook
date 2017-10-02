//: Draw the letter N. The left and right lines should be 90 long and parallel to each other. The diagonal line should be 104 long.
//:
//: In order to draw the N, you'll need to calculate the size of the turns you need to make if the angle between the right diagonal line is 30 degrees.
//:
//#-hidden-code
import PlaygroundSupport
import SpriteKit

_setup()

func addShape(pen: Pen){
    let view = PlaygroundPage.current.liveView as! GridPaperView
    view.add(pen)
}

makeAssessment(of: PlaygroundPage.current.text)
//#-end-hidden-code
//#-end-hidden-code

var p = Pen()
//#-editable-code

p.addLine(distance: 100)
p.turn(degrees: 120)

//#-end-editable-code
addShape(pen: p)

