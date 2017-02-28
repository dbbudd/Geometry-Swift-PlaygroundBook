//: Now let's fill in our shapes so they are solid.
//: Copy the following code to create a new program.
//:
//: ![Image 1](Post7_1.jpg)
//:
//: Run the program to see what happens.
//: In order to create a second shape which will be layered inside we must create a new pen object and fill it separately.  This means when designing patterns you must think about layering your shapes.
//:
//: ![Image 2](Post7_2.jpg)
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
