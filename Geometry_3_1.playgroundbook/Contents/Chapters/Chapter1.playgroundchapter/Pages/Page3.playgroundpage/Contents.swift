//: Using the `addLine()` and `turn()` commands, write a program that will draw a right angle.
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
//#-end-editable-code

addShape(pen:p)


