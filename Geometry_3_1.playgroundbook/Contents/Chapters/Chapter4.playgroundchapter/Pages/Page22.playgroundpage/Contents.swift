/*:
The American flag, is the national flag of the United States.  It consists of thirteen equal horizontal stripes of red (top and bottom) alternating with white, with a blue rectangle in the canton (referred to specifically as the “union”) bearing fifty small, white, five-pointed stars arranged in nine offset horizontal rows.
 
The 50 stars on the flag represent the 50 states of the United States of America, and the 13 stripes represent the thirteen British colonies that declared independence from the Kingdom of Great Britain.
 */
//: ![Image 1](USA.png)
/*:
 **Create a function called `usa()` which utilises your `rectangle()` and `star()` functions to draw the “Stars and Stripes”.**
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

