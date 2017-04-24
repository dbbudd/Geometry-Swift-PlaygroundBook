//: Draw a line of three shapes - a square, a triangle and another square, just like in the image below.
//:
//: ![Image 1](Post8_1.jpg)
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

var p:Pen = Pen()

//#-editable-code
//#-end-editable-code

addShape(pen:p)
