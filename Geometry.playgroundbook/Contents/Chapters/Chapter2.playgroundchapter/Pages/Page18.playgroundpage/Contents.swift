//: Draw the letter N. The left and right lines should be 90 long and parallel to each other. The diagonal line should be 104 long.
//:
//: In order to draw the N, you'll need to calculate the size of the turns you need to make if the angle between the right diagonal line is 30 degrees.
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

