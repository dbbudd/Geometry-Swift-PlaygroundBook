/*:
Flag was created to rally support for independence from Spain.  In 1898, the flag became the mark of resistance to the US invasion and in 1952 it was officially adopted as the national flag when Puerto Rico became part of the Commonwealth.
*/
//: ![Image 1](Puerto.png)
/*:
**Utilise your `rectangle()` and `star()` function to create a new function called `rico()`.  When called the function will create the flag of Puerto Rico.**
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

