//: Write a single function `drawPolygon` that will draw any regular polygon. You should use parameters to set the number of sides annd the length of each side. The angle that you will need to turn for each shape can be found using the formula `360 / n` where `n` is the number of sides. Combine the use of this function with a loop to draw the image shown below.
//:
//: ![Image 1](Post1_1.jpg)
//:
//: Run the program to see what happens.
//: By defining a function called `drawSquare` we are telling the computer how to draw a square. We then call that function in our program to actually draw the square.
//: Now change the program so that it draws three squares next to each other like in the image below.
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

