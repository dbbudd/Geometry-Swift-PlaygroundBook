//: A parallelogram is a shape where opposite sides are equal (like a rectangle) but it's tilted on one side. Opposite sides of a parallelogram are also parallel to each other!
//:
//: Write a program to draw a parallelogram shape like the one below.
//:
//: ![Parallelogram](Parallelogram.png)
//:
//#-hidden-code
import PlaygroundSupport
import SpriteKit

_setup()

func addShape(pen: Pen){
    let view = PlaygroundPage.current.liveView as! GridPaperView
    view.add(pen)
}
//#-end-hidden-code
//#-editable-code
//Create a new Pen()
var p: Pen = Pen()

p.addLine(distance: 100)
p.turn(degrees: 90)

// Add our path to the canvas
addShape(pen: p)
//#-end-editable-code

