//: We can also change the width of the line that we are drawing.
//:
//: ![Image 1](Post4_1.jpg)
//:
//: Run the program to see what happens.
//: Now change the program so that it uses a pen width of 10 and see what happens.
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
