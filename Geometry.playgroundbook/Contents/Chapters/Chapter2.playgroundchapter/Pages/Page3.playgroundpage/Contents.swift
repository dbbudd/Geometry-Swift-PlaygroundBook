//: Let's add some colour to our pictures.  Copy the following code to create a new program.
//:
//: ![Image 1](Post3_1.jpg)
//:
//: Run the program to see what happens.
//: Now change the program so that it uses green lines instead.
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

