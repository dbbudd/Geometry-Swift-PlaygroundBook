//
//  Assessments.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import Book

let success = NSLocalizedString("### You’re getting really good at this! \nDefining a function using [parameters](glossary://parameter) can make the function more [reusable](glossary://reusability), meaning you can call it in many more situations.\n\nNow that you’ve defined `move`, you’ll be able to use it as a [method](glossary://method) on the `Character` and `Expert` types. For example, `expert.move(distance: 4)` will move the `expert` instance forward four tiles. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("First, [define](glossary://define) the `move` function. In the function, write a `for` loop that uses the `distance` value to determine how many times the loop runs.", comment:"Hint"),
    NSLocalizedString("Your `for` loop could start off like this: \n`for i in 1 ... distance`\n", comment:"Hint"),
    NSLocalizedString("After you write your `move` function, call it and pass in an [argument](glossary://argument) to move your character forward by the number of tiles defined for `distance`. For example, `move(distance: 5)` will move your character forward five tiles.", comment:"Hint")
]


let solution = "```swift\nlet expert = Expert()\n\nfunc move(distance: Int) {\n   for i in 1...distance {\n      expert.moveForward()\n   }\n}\n\nmove(distance: 6)\nexpert.turnRight()\nmove(distance: 2)\nexpert.turnRight()\nmove(distance: 5)\nexpert.turnLeft()\nmove(distance: 5)\nexpert.turnLeft()\nexpert.turnLockUp()\nexpert.turnLeft()\nmove(distance: 3)\nexpert.turnRight()\nmove(distance: 3)\nexpert.turnRight()\nmove(distance: 4)\nexpert.collectGem()"


public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
