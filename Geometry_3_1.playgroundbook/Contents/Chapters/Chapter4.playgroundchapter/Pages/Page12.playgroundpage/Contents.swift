/*:
 A number of flags for localities in the United Kingdom (primarily Scotland) are based on Nordic cross designs, intended to reflect the Scandinavian heritage introduced to the British Isles during the Viking Age.
*/
//: ![Image 1](George.png)
/*:
 **Create a function called `george()` which when called with draw the English flag.**
*/
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

