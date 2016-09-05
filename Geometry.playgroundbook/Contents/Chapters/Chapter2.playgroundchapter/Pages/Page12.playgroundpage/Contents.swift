//: Two lines are parallel if they're always the same distance apart. When another line cross parallel lines, it's called a traversal.
//: The lines below are parallel, with a traversal line crossing them.
//:
//: ![Image 1](Post12_1.jpg)
//:
//: As you can see in the image below you cans ee that you can apply rules to figure out the angle you need to turn based on their relationships.
//: 1. Alternating angles on parallel lines are equal.
//: 2. Co-interior angles are different to all the rest. A pair of co-interior angles will sum to 180 degrees (called supplementary).
//: 3. Corresponding angles on parallel lines are equal
//: 4. Opposite angles are equal.
//:
//: ![Image 2](Post12_2.jpg)
//:
//: Knowing which angles crossing parallel lines and within shapes are related makes it much easier to draw them.
//#-hidden-code
import PlaygroundSupport
import SpriteKit

let scene: GridScene = GridScene(size:CGSize(width:2048, height:1536))
let view: SKView = SKView(frame: CGRect(x:0, y:0, width:scene.size.width, height:scene.size.height))
view.presentScene(scene)
PlaygroundPage.current.liveView = view


//#-end-hidden-code
//#-editable-code
//Create a new Pen()
var p: Pen = Pen()

p.addLine(distance: 100)
p.turn(degrees: 90)

// Add our path to the canvas
scene.addPen(pen: p)
//#-end-editable-code
