//: Write a program that uses a while look which draws a tetradecagon. A Tetradecagon is a shape with 14 sides!
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
