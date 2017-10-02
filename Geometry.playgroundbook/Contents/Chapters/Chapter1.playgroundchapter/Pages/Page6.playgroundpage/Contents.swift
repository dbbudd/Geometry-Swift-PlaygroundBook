//: Write a program that will draw a triangle inside a square, just like in the image below.
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

makeAssessment(of: PlaygroundPage.current.text)
//#-end-hidden-code

var p = Pen()

//#-editable-code
//#-end-editable-code

addShape(pen:p)




