//: Using three different loops, draw a triangle, square and pentagon as shown below.
//:
//: ![Image 1](Post5_1.jpg)
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
