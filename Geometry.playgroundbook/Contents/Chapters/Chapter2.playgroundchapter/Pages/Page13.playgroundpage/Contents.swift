//: Given waht you have just learnt about parallel lines, you now need to draw the letter Z.
//:
//: ![Image 1](Post13_1.jpg)
//:
//: In order to draw the Z, you'll need to calculate the size of the turn you need to make if the angle between the top and diagonal line is 60 degrees. The pen should start drawing from the top left corner (0, 0).
//:
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

