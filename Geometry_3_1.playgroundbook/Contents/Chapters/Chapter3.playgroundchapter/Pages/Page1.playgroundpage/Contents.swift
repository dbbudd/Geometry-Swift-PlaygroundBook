//: If we want to repeat the same thing a number of times, we can use a for-loop.
//: For example, when we draw a square, we need to move forwrd then turn four times - once for each side of the square.
//: Copy the following code:
//:
//: ![Image 1](Post1_1.jpg)
//:
//: Run the program to see what happens.
//: Now change the program so that it draws a regular octagon (a shape with 8 sides all the same length).
//:
//: ![Image 2](Post1_2.jpg)
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
p.turn(degrees: 120)

//#-end-editable-code
addShape(pen: p)
