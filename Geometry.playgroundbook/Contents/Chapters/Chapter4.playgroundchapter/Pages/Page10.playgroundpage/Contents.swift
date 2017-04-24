/*:
The flag of Scotland also known as St Andrew’s Cross or the Saltire, is the national flag of Scotland.  St Andrew was a fisherman and one of Jesus’ first Apostles. He was sentenced to death by crucifixion by the Romans in Greece, but asked to be crucified on a diagonal cross as he felt he wasn’t worthy to die on the same shaped cross as Jesus.
 */
//: ![Image 1](Andrew.png)
/*:
 **Create a function called `andrew()` which will draw the flag of Saint Andrew.**
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

