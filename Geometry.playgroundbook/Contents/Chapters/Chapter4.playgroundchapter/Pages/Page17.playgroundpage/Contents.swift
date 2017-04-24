/*:
The national flag of France was designed in 1794.  As a forerunner of revolution, France’s tricolour flag style has been adopted by other nations such as Italy, Costa Rica, Dominican Republic, Ireland, Haiti, Romania and Mexico.
*/
//: ![Image 1](France.png)
/*:
 **Draw the flag of France using a function called `rectangle()` which accepts a colour parameter.. You must also use a for-loop.**
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

