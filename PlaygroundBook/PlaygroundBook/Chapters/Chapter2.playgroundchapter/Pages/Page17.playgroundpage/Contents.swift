//: Given what you have just learnt about parallel lines, you now need to draw the letter Z.
//:
//: ![Image 1](Post13_1.jpg)
//:
//: In order to draw the Z, you'll need to calculate the size of the turn you need to make if the angle between the top and diagonal line is 60 degrees. The pen should start drawing from the top left corner (0, 0).
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

p.addLine(distance: 100)
p.turn(degrees: 90)

//#-end-editable-code
addShape(pen: p)

