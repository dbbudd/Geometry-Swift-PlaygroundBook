/*:
The flag of the Netherlands is the oldest tricolour design.  Its three colours of red, white and blue go back to Charlemagne’s time, the 9th century.  The tricolour flag became a symbol of republicanism, liberty and independence against Great Britain.
*/
//: ![Image 1](Netherlands.png)
/*:
 **Draw the flag of Netherlands using a function called `rectangle()` which accepts a colour parameter.**
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
