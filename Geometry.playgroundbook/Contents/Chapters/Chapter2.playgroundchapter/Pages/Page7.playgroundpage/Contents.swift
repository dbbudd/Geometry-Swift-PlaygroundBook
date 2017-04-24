//: Draw a yellow diamond with a pen line width of 15, like in the image below.
//:
//: ![Image 1](Post6_1.jpg)
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

var p: Pen = Pen()

//#-editable-code
//#-end-editable-code

addShape(pen: p)

