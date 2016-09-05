//: You've learned how to make the pen turn left, but we can also make the pen turn right.
//: Just like before, if we insert a negative number rather then a positive one, it will manipulate the direction the pen rotates.
//:
//: ![Image 1](Post2_1.jpg)
//:
//: Try guessing what this program will draw before running the example.
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
