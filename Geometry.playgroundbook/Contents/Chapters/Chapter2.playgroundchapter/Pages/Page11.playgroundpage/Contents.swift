//: Use the pen to draw a house!
//:
//: The triangle at the top should have angles that are all 60 degrees and all sides of the house should be 100 in length. The sides of the roof will also be 100 long.
//:
//: The result should look like this:
//:
//: ![house](house.png)
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
//#-end-editable-code

