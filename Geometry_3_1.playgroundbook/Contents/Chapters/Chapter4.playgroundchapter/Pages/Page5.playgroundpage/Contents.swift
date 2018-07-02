//: What happens if we have written a function to draw a square, but now we want to change the size of the square?
//: We need to use parameter to tell the function how big to make our square.
//:
//: ![Image 1](Post4_1.jpg)
//:
//: Run the program to see what it does.
//: Add two lines to the program to draw two more squares - one with sides of 200 and one with sides of 300.
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

//#-editable-code
var p = Pen()

p.addLine(distance: 100)
p.turn(degrees: 90)

addShape(pen: p)
//#-end-editable-code
