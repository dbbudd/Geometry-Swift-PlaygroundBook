//: Using multiple `Pen()` objects re-create the multiple squares in different colours.
//:
//: ![Image 1](coloured_squares.PNG)
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
//#-end-editable-code
