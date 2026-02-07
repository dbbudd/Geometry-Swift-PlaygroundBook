//
//  Assessments.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import Book

let solution = "```swift\nfor i in 1 ... 4 {\n   moveForward()\n   collectGem()\n   moveForward()\n   moveForward()\n   moveForward()\n   turnRight()\n}\n```"

import PlaygroundSupport
public func assessmentPoint() -> AssessmentResults {
    let checker = ContentsChecker(contents: PlaygroundPage.current.text)
    
    var success = NSLocalizedString("### Excellent! \nNow you know how to add a loop structure to your code.\n\n[**Next Page**](@next)", comment:"Success message")
    var hints = [
        NSLocalizedString("Add a `for` loop to your code by selecting `for` in the shortcut bar.", comment:"Hint"),
        NSLocalizedString("The basic sequence for each side of the square is to collect the gem, move forward three times, then turn right.", comment:"Hint")
    ]
    
    if checker.didUseWhileLoop {
        success = NSLocalizedString("### Wow! Using `while` loops already? Excellent work! \n\n[**Next Page**](@next)", comment:"Success message")
        
    } else if checker.didUseForLoop {
        success = NSLocalizedString("### Excellent! \nNow you know how to add loop structures to your code.\n\n[**Next Page**](@next)", comment:"Success message")
        hints[0] = NSLocalizedString("Try dragging the bottom curly brace of your `for` loop down to bring the existing commands up into the loop.", comment:"Hint")
    } else if !checker.didUseForLoop {
        success = NSLocalizedString("### Don’t forget to use a loop. \nYour solution will be much simpler if you use a `for` loop. Give it a shot.\n", comment:"Success message")
        hints[0] = NSLocalizedString("Add a `for` loop to your code by selecting `for` in the shortcut bar. Drag the bottom curly brace down to bring the existing commands up into the loop.", comment:"Hint")
    }
    
    
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
