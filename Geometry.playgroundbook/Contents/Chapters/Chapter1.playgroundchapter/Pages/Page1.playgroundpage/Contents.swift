//: The pen follows instructions from its point of view. Think of it as your hand moving across the page from left to right with an ink trail being left behind.
//:
//: ![Image 1](Post1_1.jpg)
//:
//: You must always give an instruction to the pen and tell it the distance you want it to travel. As it moves, it draws a line, so you can draw shapes, patterns and pictures.
//:
//: ![Image 2](Post1_2.jpg)
//:
//: In the coe above we've drawn a triangle with 60 degrees internal angles (120 degree external angles), and 200 pixels distance for each of its edges. Since the sides are of equal length, we've drawn an equilateral triangle.
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
var p:Pen = Pen()

p.addLine(distance: 200)

// Add our path to the canvas
scene.addPen(pen:p)
//#-end-editable-code


