//: The simulator is setup on a grid.  Just like with a grid if you subtract a value on the x-axis is will move left and if you add a value it will move right. This is similar for the y-axis.  If you have a positive value it will move up and if you have a negative number it will move down.
//:
//: ![Image 1](Post1_1.jpg)
//:
//#-hidden-code
//: Using two triangles, draw a Star of David like the image below.
//:
//: ![Image 1](Post10_1.jpg)
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



