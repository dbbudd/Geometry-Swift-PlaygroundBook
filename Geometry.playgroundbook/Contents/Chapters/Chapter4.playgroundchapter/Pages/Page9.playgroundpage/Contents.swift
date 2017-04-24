/*:
Until 1938 the Norwegian flag was only used in Northern waters because Norway had no treaty with the Barbary pirates of North Africa and had to fly the Swedish or union flag for protection.  In 1844 a union mark combining Norwegian and Swedish colours was placed at the hoist of both countries flags.. The flag was jokingly called Sildesalaten (“the herring salad”) because of its jumble of colours and resemblance to a popular dish on the breakfast tables of both countries.
 */
//: ![Image 1](Norway.png)
/*:
 **Modify the line properties in your `nordic()` function to create the Norwegian flag**
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

