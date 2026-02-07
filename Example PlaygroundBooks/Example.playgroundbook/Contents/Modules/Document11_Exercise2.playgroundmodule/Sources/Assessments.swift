//
//  Assessments.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import Book

let success = NSLocalizedString("### Awesome! \nYou’ve created a new function that takes [parameters](glossary://parameter). That’s a huge step toward creating reusable pieces of code. When a function takes multiple parameters, you can customize multiple parts of that function’s behavior. You now have access to both the `move` and `turnLock` functions for future puzzles. Use them with the `Character` and `Expert` types using dot notation. For example, `expert.move(distance: 4)` and `expert.turnLock(up: true, numberOfTimes: 2)` each use these new methods. \n\n[**Next Page**](@next)", comment:"Success message")
let hints = [
    NSLocalizedString("First, you’ll need to define the `turnLock` function so that it uses the `up` [parameter](glossary://parameter) to tell the expert which direction to turn the lock. Then use `numberOfTimes` to set the number of times to turn the lock.", comment:"Hint"),
    NSLocalizedString("The `up` parameter takes an input of type Bool ([Boolean](glossary://Boolean)). You can check the Boolean value with an `if` statement, and then run `turnLockUp()` if true and `turnLockDown()` if `false`.", comment:"Hint")
]

let solution = "```swift\nlet expert = Expert()\nlet character = Character()\n\nfunc turnLock(up: Bool, numberOfTimes: Int) {\n   for _ in 1...numberOfTimes {\n     if up == true {\n         expert.turnLockUp()\n      } else {\n         expert.turnLockDown()\n      }\n   }\n}\n\nfunc expertTurnAround() {\n   expert.turnLeft()\n   expert.turnLeft()\n}\n\nfunc characterTurnAround() {\n   character.turnLeft()\n   character.turnLeft()\n}\n\nturnLock(up: true, numberOfTimes: 3)\nexpertTurnAround()\nturnLock(up: true, numberOfTimes: 3)\ncharacter.move(distance: 3)\ncharacter.collectGem()\n\ncharacterTurnAround()\nfor i in 1...2 {\n   character.moveForward()\n   character.turnLeft()\n}\nturnLock(up: false, numberOfTimes: 3)\nexpertTurnAround()\nturnLock(up: false, numberOfTimes: 2)\ncharacter.moveForward()\ncharacterTurnAround()\ncharacter.collectGem()\ncharacter.moveForward()\nexpert.turnLockDown()\ncharacter.move(distance: 2)\ncharacter.collectGem()"

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
