/*:
After the French military dictator Napoleon was defeated by the European powers in 1815, conservative politicians in Switzerland tried to restore the old political institutions. The Helvetic Tricolor was abandoned and William Tell then interpreted a revolution hero, was banned from Switzerland’s seal and replaced by the white Swiss Cross on red background.
*/
//: ![Image 1](Switzerland.png)
/*:
 **Modify your `rectangle()` function to accept heights, width and coordinates.  Use the new function to create the Swiss Cross.**
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

