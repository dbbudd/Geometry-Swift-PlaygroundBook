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

_setup()

func addShape(pen: Pen){
    let view = PlaygroundPage.current.liveView as! GridPaperView
    view.add(pen)
}

makeAssessment(of: PlaygroundPage.current.text)
//#-end-hidden-code

//#-editable-code
var p = Pen()

p.addLine(distance: 100)
p.turn(degrees: 90)

addShape(pen: p)
//#-end-editable-code

