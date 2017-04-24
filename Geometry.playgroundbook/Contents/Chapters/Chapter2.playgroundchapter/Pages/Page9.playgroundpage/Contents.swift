//: Often you want the penColor and the fillColor to be the same.
//: To create multiple shapes with different properties you must draw them one at a time using multiple `Pen()` objects.
//:
//: ![Image 1](Post8_1.png)
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
