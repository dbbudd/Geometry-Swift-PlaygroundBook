//: Using a loop, draw the shape below.
//:
//: ![Image 1](Post7_1.png)
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

var p = Pen()
//#-editable-code

p.addLine(distance: 100)
p.turn(degrees: 90)

//#-end-editable-code
addShape(pen: p)

