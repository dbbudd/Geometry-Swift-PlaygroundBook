/*:
From the middle of the nineteenth century, a growing Australian nationalism brought forth many unofficial flags – all of them incorporating the constellation of the Southern Cross (Crux Australis), which was universally accepted as the emblem of the Great Southern Land.
 */
//: ![Image 1](Australia.png)
/*:
 **Using your functions you have previously created draw the Australian flag.  Note that the star under the Union Jack has seven points to represent the federation of colonies to form six states plus territories. All the functions should be called within a single function called `australia()` **
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
