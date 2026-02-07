//
//  Assessments.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import Book

let success = NSLocalizedString("### Nice work! \nYou can now place your character or expert anywhere you want in the puzzle world after you [initialize](glossary://initialization) them. You called the `place` [method](glossary://method) on `world`, which is an [instance](glossary://instance) of the puzzle world itself ([type](glossary://type) GridWorld). \n\n[**Next Page**](@next)", comment:"Success message")
let successGetStartedWithSwift = NSLocalizedString("### Nice work! \nYou can now place your character or expert anywhere you want in the puzzle world after you [initialize](glossary://initialization) them. You called the `place` [method](glossary://method) on `world`, which is an [instance](glossary://instance) of the puzzle world itself ([type](glossary://type) GridWorld).", comment:"Success message in Get Started with Swift")
let hints = [
    NSLocalizedString("You can touch a tile to see its coordinate value. Find the location you’d like your expert to start at, then touch the tile to figure out which column and row value to pass into your `place` method.", comment:"Hint"),
    NSLocalizedString("Use the example as a guide to pass your [arguments](glossary://argument) into the `place` [method](glossary://method).", comment:"Hint"),
    NSLocalizedString("First, pass `expert` into the `item` [parameter](glossary://parameter). Then pass in two [Int](glossary://Int) values for `atColumn` and `row` to indicate the coordinate you want your expert to start at.", comment:"Hint"),
    NSLocalizedString("Place your expert in a location that will allow you to collect all of the gems in the puzzle.", comment:"Hint")
]


let solution = "```swift\nlet expert = Expert()\nworld.place(expert, atColumn: 2, row: 6)\n\nfunc turnAround() {\n   expert.turnLeft()\n   expert.turnLeft()\n}\n\nfunc turnLockCollectGem() {\n   expert.turnLeft()\n   expert.turnLockUp()\n   turnAround()\n   expert.moveForward()\n   expert.collectGem()\n   turnAround()\n   expert.moveForward()\n   expert.turnRight()\n}\n\nturnLockCollectGem()\nexpert.move(distance: 5)\nturnLockCollectGem()\nexpert.move(distance: 6)\nexpert.collectGem()"


public func assessmentPoint() -> AssessmentResults {
    var successMessage = success
    if let _ = Bundle.main.url(forResource: "HB_C01_Commands", withExtension: "storyboardc") {
        // Get Started with Swift has a different success message.
        successMessage = successGetStartedWithSwift
    }
    return updateAssessment(successMessage: successMessage, failureHints: hints, solution: solution)
}
