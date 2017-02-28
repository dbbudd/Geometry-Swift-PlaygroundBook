//: When you want the angle between two lines to be 30 degrees, the first thing you might try is to turn 30 degrees, then draw the next line.
//:
//: ![Image 1](Post10_1.jpg)
//:
//: But turning 30 degrees is not far enough! The pen needs to turn much ruther to make the angle 30 degrees between the lines.
//: The correct turn is actually 180 - 30 = 150.  We want to almost reverse (turn 180 degrees) but stop when we're 30 degrees from the old direction.
//:
//: ![Image 2](Post10_2.jpg)
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
