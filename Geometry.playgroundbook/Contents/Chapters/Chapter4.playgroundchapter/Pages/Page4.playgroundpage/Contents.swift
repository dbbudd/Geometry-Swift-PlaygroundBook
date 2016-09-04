//: What happens if we have written a function to draw a square, but now we want to change the size of the square?
//: We need to use parameter to tell the function how big to make our square.
//:
//: ![Image 1](Post4_1.jpg)
//:
//: Run the program to see what it does.
//: Add two lines to the program to draw two more squares - one with sides of 200 and one with sides of 300.
//#-hidden-code
import PlaygroundSupport
import SpriteKit

let scene: CanvasScene = CanvasScene(size:CGSize(width:2048, height:1536))
let view: SKView = SKView(frame: CGRect(x:0, y:0, width:scene.size.width, height:scene.size.height))
view.presentScene(scene)
PlaygroundPage.current.liveView = view

func addShape(pen: Pen){
    scene.canvas.addChild(Shape(pen:pen).node)
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
