/*:
 Denmark is Europe’s oldest kingdom and its flag – the oldest European flag – was officially adopted in 1625. The red flag with a white cross is known as the Dannebrog, or Danish Cloth.  The Nordic or Scandinavian cross is a symbol in a rectangular field, with the center of the cross shifted towards the hoist.  All of the Nordic countries except Greenland have adopted such flags in the modern period.  The cross design represents Christianity.
*/
//: ![Image 1](Denmark.png)
/*:
 **Create a function called `nordic()` which will draw flag of Denmark**
 */
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
//Create a new Pen()
var p: Pen = Pen()

p.addLine(distance: 100)
p.turn(degrees: 90)

// Add our path to the canvas
addShape(pen: p)
//#-end-editable-code

