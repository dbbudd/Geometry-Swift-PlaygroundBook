//: If we want to repeat the same thing a number of times, we can use a for-loop.
//: For example, when we draw a square, we need to move forwrd then turn four times - once for each side of the square.
//: Copy the following code:
//:
//: ![Image 1](Post1_1.jpg)
//:
//: Run the program to see what happens.
//: Now change the program so that it draws a regular octagon (a shape with 8 sides all the same length).
//:
//: ![Image 2](Post1_2.jpg)
//:
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
