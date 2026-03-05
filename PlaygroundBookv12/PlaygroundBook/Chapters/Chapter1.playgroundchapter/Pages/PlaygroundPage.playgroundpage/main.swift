//#-hidden-code
//
//  See LICENSE folder for this template’s licensing information.
//
//  Abstract:
//  The Swift file containing the source code edited by the user of this playground book.
//


Scene {
//#-end-hidden-code

    var square = Pen()
    square.penColor = .systemRed
    square.lineWidth = z
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
