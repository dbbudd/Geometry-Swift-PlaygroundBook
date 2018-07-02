//: Write a program which can draw a variable sized house. If the variable called `size` is changed the house will be drawn proportionally.
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

//#-editable-code
let size = 10.0



//#-end-editable-code

