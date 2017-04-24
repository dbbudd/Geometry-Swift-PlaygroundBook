/*:
 If we insert a negative number rather then a positive one, it will manipulate the direction of the `Pen()`.
 - - -
 ````
 var p: Pen = Pen()
 
 p.turn(degrees: 30)
 p.addLine(distance: 100)
 p.turn(degrees: -60)
 p.addLine(distance: 100)
 p.turn(degrees: 60)
 p.addLine(distance: 100)
 
 addShape(pen: p)
 ````
 **Try guessing what the code above will draw before copying and executing it**
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
//#-end-editable-code
