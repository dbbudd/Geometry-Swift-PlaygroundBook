//: Let's draw a 6-pointed snowflake with a thicker pen and some colour!
//:
//: Write a program to:
//: * Set the pen size to 10.0.
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

makeAssessment(of: PlaygroundPage.current.text)
//#-end-hidden-code

var p = Pen()
//#-editable-code

p.addLine(distance: 100)
p.turn(degrees: 90)

//#-end-editable-code
addShape(pen: p)

