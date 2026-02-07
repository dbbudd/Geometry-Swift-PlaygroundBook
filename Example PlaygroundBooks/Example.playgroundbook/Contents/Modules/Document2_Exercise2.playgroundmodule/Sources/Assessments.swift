//
//  Assessments.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import Book

let solution = "```swift\nfunc turnRight() {\n   turnLeft()\n   turnLeft()\n   turnLeft()\n}\n\nmoveForward()\nturnLeft()\nmoveForward()\nturnRight()\nmoveForward()\nturnRight()\nmoveForward()\nturnRight()\nmoveForward()\nturnLeft()\nmoveForward()\ntoggleSwitch()"

import PlaygroundSupport
func evaluateContents(_ contents: String) -> (success: String, hints: [String]) {
    let checker = ContentsChecker(contents: contents)
    
    var hints = [
        NSLocalizedString("Remember, `turnRight()` is a combination of three left turns.", comment:"Hint"),
        NSLocalizedString("Use `turnRight()` any time you want to make a right turn.", comment:"Hint"),
        
        ]
    
    var success = NSLocalizedString("### You just wrote your first [function](glossary://function)! \nYou can now use functions to create new abilities. To create a new [function](glossary://function), give it a name and [define](glossary://define) it by giving it a set of commands. Then [call](glossary://call) the function to make it run. \n\n[**Next Page**](@next)", comment:"Success message")
    
    let expectedContents = [
        "turnLeft",
        "turnLeft",
        "turnLeft"
    ]
    
    
    let turnRightMoveForward = [
        "turnLeft",
        "turnLeft",
        "turnLeft",
        "moveForward"
    ]
    
    if !checker.function("turnRight", matchesCalls: expectedContents) {
        hints[0] = NSLocalizedString("First you need to [define](glossary://define) `turnRight()` correctly. To do this, select the `turnRight()` function body and add three `turnLeft()` commands. Then use `turnRight()` to complete the puzzle.", comment:"Hint")
        success = NSLocalizedString("### You’re on your way! \nYou were able to solve the puzzle, but you didn’t correctly [define](glossary://define) `turnRight()`. To improve your coding skills, go back and define `turnRight()` using three `turnLeft()` commands, then solve the puzzle again.", comment:"Success message")
    } else if checker.functionCallCount(forName: "turnLeft") >= 4 {
        hints[0] = NSLocalizedString("After you define `turnRight()`, you no longer have to call `turnLeft()` three times for each right turn. Instead, call `turnRight()`, and three `turnLeft()` commands will run.", comment:"Hint")
    } else if world.commandQueue.closedAnOpenSwitch() {
        hints[0] = NSLocalizedString("Remember, you want all the switches toggled open. If a switch is already open, just leave it as it is.", comment:"Hint")
    }
    
    if checker.function("turnRight", matchesCalls: expectedContents) && checker.functionCallCount(forName: "turnRight") < 1 {
        success = NSLocalizedString("You [defined](glossary://define) your `turnRight()` function correctly, but you didn’t use it to solve the puzzle. Once you’ve defined `turnRight()`, use it each time you need your character to turn right.", comment:"Success message")
    }
    
    if checker.function("turnRight", matchesCalls: turnRightMoveForward) {
        success = NSLocalizedString("### You just wrote your first [function](glossary://function)! \nIn addition to turning right, however, your function also moves your character forward one tile. While that might work fine for this puzzle, you might not always want to move forward when you call `turnRight()`. Try going back and changing the `turnRight()` function so that the only thing it does is turn your character to the right.", comment:"Success message")
    }
    if checker.didUseForLoop {
        success = NSLocalizedString("### You just wrote your first [function](glossary://function)! \nNice work using a [`for` loop](glossary://for%20loop) to write `turnRight`. You must really know your stuff! You can now use functions to create new abilities. To create a new [function](glossary://function), give it a name and [define](glossary://define) it by giving it a set of commands. Then [call](glossary://call) the function to make it run. \n\n[**Next Page**](@next)", comment:"Success message")
    }
    return (success, hints)
}
public func assessmentPoint() -> AssessmentResults {

    let (success, hints) = evaluateContents(PlaygroundPage.current.text)
    
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
