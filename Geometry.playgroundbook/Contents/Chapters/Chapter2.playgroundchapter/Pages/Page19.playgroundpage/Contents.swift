//: A rhombus is a shape where all the sides are equal (like a square) but it's tilted to one side. Opposite sides of a rhombus are parallel to each other and all sides of the rhombus should be 100 long (like a square).
//:
//: Write a program to draw a rhombus shape like the one below.
//:
//: ![Rhombus](Rhombus.png)
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
