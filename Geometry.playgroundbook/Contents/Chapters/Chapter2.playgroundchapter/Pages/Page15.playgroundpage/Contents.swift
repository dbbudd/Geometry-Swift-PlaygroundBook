//: Let's draw a 6-pointed snowflake with a thicker pen and some colour!
//:
//: Write a program to:
//: * Set the pen size to 5.
//: * Set the pen colour to light blue
//: * Draw a 6 pointed snowflake with arms 100 long 60 degrees between each arm.
//:
//: When it's finished, the result should look like this:
//:
//: ![Snowflake](snowflake.jpg)
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
