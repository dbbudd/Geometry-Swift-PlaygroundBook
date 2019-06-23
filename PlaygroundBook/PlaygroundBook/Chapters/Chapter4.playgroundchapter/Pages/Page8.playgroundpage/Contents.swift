/*:
 The flag of Sweden was officially adopted on June 22, 1906. The off-centred yellow cross (the Scandinavian Cross) is taken from the Danish flag. The yellow and blue colours are taken from the national coat of arms. Flag Day in Sweden is celebrated each year on June 6th. On this date in 1523, King Vasa began his reign and Sweden was no longer under the control of Denmark.
 */
//: ![Image 1](Sweden.png)
/*:
 **Modify your `nordic()` function from the previous task to allow for colour parameters and draw the Swedish flag.**
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

