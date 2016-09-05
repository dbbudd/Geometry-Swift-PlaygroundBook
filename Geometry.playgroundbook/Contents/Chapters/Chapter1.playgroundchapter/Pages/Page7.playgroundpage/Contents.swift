//: You have already used the `addLine()` command, but you can also use the `move()` command. The `move()` command will behave the same as the `addLine()` but it won't draw a line.
//:
//: ![Image 1](Post7_1.jpg)
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


