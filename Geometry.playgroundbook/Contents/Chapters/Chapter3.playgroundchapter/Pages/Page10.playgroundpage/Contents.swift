//: Instead of using a for-loop we can use a while-loop where we can use a counter a part of the loop.
//:
//: ![Image 1](Post10_1.jpg)
//:
//: Run the program to see what it does.
//: Now modify the program so taht the distance between each line in the spiral is 10. Your finished program should look like the image below.
//:
//: ![Image 2](Post10_2.jpg)
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

