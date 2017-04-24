/*:
 **Copy the code below and modify it so that a square is drawn**
 - - -
 ````
 var p: Pen = Pen()
 
 p.addLine(distance: 100)
 p.turn(degrees: 120)
 p.addLine(distance: 100)
 p.turn(degrees: 120)
 p.addLine(distance: 100)
 p.turn(degrees: 120)
 
 addShape(pen: p)
 ````
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

//#-end-editable-code



