//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//


Scene {
//#-end-hidden-code

//: # Geometry with Swift
//: Welcome to Geometry with Swift. Get started by pressing the **Run My Code** button and exploring the output.

    var square = Pen()
    square.penColor = .systemRed
    square.lineWidth = 4
    square.addLine(distance: 100)
    square.turn(degrees: 90)
    square.addLine(distance: 100)
    square.turn(degrees: 90)
    square.addLine(distance: 100)
    square.turn(degrees: 90)
    square.addLine(distance: 100)
    addShape(pen: square)

//#-hidden-code
}
//#-end-hidden-code
