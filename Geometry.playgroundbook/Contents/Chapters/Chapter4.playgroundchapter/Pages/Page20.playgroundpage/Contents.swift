/*:
The flag of Tonga is one of the oldest flags of the island countries in the South Pacific Ocean. The flag's widely recognised red cross is symbolic of Christianity coming to the islands; white symbolises purity, and red represents the blood of Christ.
 */
//: ![Image 1](Tonga.png)
/*:
 **Create a function called `tonga()`. When called the function will draw the flag of Tonga**
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

