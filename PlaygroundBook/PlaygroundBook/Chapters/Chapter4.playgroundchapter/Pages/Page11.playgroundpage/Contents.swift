/*:
The Order of Saint Patrick, an Anglo-Irish chivalric order, was creased in 1783. The order was a means of rewarding those in high office who supported the Anglo-Irish government of Ireland. On its badge was a red saltire on a white background, which it called the “Cross of St Patrick” Some contemporary responses to the badge complained that an X-shaped cross was the Cross of St Andrew, patron of Scotland.
*/
//: ![Image 1](Patrick.png)
/*:
 **Modify your `andrew()` function and create a new function called `patrick()`.  When called it will draw the Cross of Saint Patrick.**
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

