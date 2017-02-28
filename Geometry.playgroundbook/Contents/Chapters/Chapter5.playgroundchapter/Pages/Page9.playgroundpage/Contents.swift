//: Add a function to draw a car.  The colour of the car should be red or blue, but the tyres should be black.  Ensure that you have an inner function called `drawTyre()`.
//:
//: Call the function a few times so that you have several cars on the road.
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
