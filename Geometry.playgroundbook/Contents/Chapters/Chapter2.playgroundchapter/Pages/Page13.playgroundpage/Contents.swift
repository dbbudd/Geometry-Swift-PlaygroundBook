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
//#-end-hidden-code
var p: Pen = Pen()

//#-editable-code
let size = 10.0

p.addLine(distance: (10.0 * size))
p.turn(degrees: 90)

//#-end-editable-code
addShape(pen: p)

