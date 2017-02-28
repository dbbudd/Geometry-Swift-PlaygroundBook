//: Write a new function which draws a house.
//: It should be similar to the church but perhaps should have a chimney (or another feature?) instead of the cross. Maybe it could have doors and windows.
//: 
//: Remember that you must close one shape before drawing the other if you wish for them to be different colours.
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

