/*:
Create a function called `star()`, which will create a filled star.
*/
//: ![Image 1](Post16_1.jpg)
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
var p = Pen()

p.addLine(distance: 100)
p.turn(degrees: 90)

addShape(pen: p)
//#-end-editable-code
