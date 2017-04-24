//: Write a program that draws three different size squares, all starting at the same spot (like the image below).
//:
//: ![Image 1](Post5_1.jpg)
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
