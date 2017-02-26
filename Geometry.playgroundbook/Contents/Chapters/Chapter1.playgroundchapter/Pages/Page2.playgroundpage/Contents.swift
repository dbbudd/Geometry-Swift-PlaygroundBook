//: The pen always starts off facing to the right (as, we write left to right).
//: 
//: If you want to change which way the pen is facing, you can use `turn()`. These functions need the angle to turn in degrees.  Here we're turning left by 90 degrees (a right angle):
//:
//: ![Image 1](Post2_1.jpg)
//:
//: Now the pen is facing the top of the screen.
//: If you turn a total of 360 degrees then the pen will end up facing the same way as how it started, because 360 degrees is a full circle:
//:
//: ![Image 2](Post2_2.jpg)
//:
//#-hidden-code
import PlaygroundSupport
import SpriteKit

_setup()

//#-end-hidden-code
//#-editable-code
//Create a new Pen()
var p:Pen = Pen()

p.addLine(distance: 200)
p.turn(degrees:90)
p.addLine(distance: 200)

// Add our path to the canvas
addShape(pen:p)
//#-end-editable-code

