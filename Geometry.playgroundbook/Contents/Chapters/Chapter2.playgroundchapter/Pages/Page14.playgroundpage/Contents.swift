//: Write a program to draw a red cross where all of the sides are 50 long. Your program must also have a variable for the line thickness so you can easily change how thick the cross is drawn.
//:
//: Here's an example of a red cross with line thickness 5:
//:
//: ![Cross 1](cross1.jpg)
//:
//: Here's an example of a red cross with line thickness 15:
//:
//: ![Cross 2](cross2.jpg)
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
