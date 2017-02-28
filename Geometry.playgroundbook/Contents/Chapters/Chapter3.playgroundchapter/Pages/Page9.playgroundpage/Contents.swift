//: Have a look at the program you did in the previous activity. Modify it so it draws four squares in a larger square shape like in the image below.
//: Each square should be 50 pixels wide, and placed 50 pixels apart. Fill each square with green.
//:
//: ![Image 1](Post9_1.jpg)
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

