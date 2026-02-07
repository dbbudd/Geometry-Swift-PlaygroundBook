//
//  Assessments.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import Book

let solution = "```swift\nmoveForward()\n\nif isOnClosedSwitch {\n   toggleSwitch()\n} else if isOnGem {\n   collectGem()\n}\n\nmoveForward()\nif isOnClosedSwitch {\n   toggleSwitch()\n} else if isOnGem {\n   collectGem()\n}\n```"


import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = NSLocalizedString("### Very creative! \nYou solved the puzzle, but you didn't use an `else if` statement. Can you try solving it using one?", comment:"Success message no else if")
    var hints = [
        NSLocalizedString("Start by moving to the first tile and using an `if` statement to check whether your character is on a closed switch.", comment:"Hint"),
        NSLocalizedString("Add an `if` statement and use the condition `isOnClosedSwitch` to check whether you should toggle a switch. Then add an `else if` block to run code if another condition is `true`.", comment:"Hint"),
        NSLocalizedString("If your character is on a closed switch, toggle it. Otherwise (the “else” part), if your character is on a gem, collect it.", comment:"Hint"),

        ]
    
    if !checker.didUseConditionalStatement("else if") {
        hints[0] = NSLocalizedString("After you’ve added an `if` statement, add an `else if` block to check for a second condition.", comment:"Hint")
        hints.remove(at: 1)
    }
    
    if checker.didUseConditionalStatement("else if") {
        success = NSLocalizedString("### Impressive! \nYou now know how to write your own `else if` statements.\n\n[**Next Page**](@next)", comment:"Success message")
    }
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
