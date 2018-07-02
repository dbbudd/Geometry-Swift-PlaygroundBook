/*:
The Union Jack or Union Flag, is the national flag of the United Kingdom. The flag also has an official or semi-official status in some other Commonwealth realms. The origins of the earlier flag of Great Britain date back to 1606 when James VI of Scotland had inherited the English and Irish thrones as James I, thereby uniting the crowns of England, Scotland and Ireland.
*/
//: ![Image 1](Union.png)
/*:
 **Create a new function called `union()`.  This function should call `andrew()`, `patrick()` and `george()` to create the Union flag.**
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
