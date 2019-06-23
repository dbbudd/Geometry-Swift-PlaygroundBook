//: Write a function called `octagons()` that will draw a regular hexagon with sides that are the length of 100.
//: Use that function to draw 8 hexagons on your page as in the image below.
//:
//: ![Image 1](Post2_1.jpg)
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
var p = Pen()

p.addLine(distance: 100)
p.turn(degrees: 90)

addShape(pen: p)
//#-end-editable-code
