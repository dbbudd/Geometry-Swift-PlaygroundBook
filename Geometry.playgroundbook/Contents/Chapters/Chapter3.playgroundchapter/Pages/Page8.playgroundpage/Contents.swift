//: Now that we can draw a shape using a single loop, how can we use loops to draw a number of the same shapes?
//: Copy the following code:
//:
//: ![Image 1](Post8_1.jpg)
//:
//: Run the program and see what it does.
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
