//#-hidden-code
//
//  main.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
**Challenge:** Create instances of type `Character` and `Expert` and have them work together to solve the puzzle.
 
 In this challenge, you’ll need to [initialize](glossary://initialization) instances of your character and your expert, and then use them together to solve the puzzle. But instead of focusing on only one instance at a time, you’ll need to mix the behaviors of both to make them work together.
 
 Start by creating an instance of your character and an instance of your expert. Use your expert to turn one of the locks so your character can reach the gem or the switch. Then pick the other lock so your character can complete the challenge.
*/
//#-code-completion(everything, hide)
//#-code-completion(identifier, hide, Page_Contents)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, ., let, =, <, >, ==, !=, +=, +, -, isBlocked, true, false, isBlockedLeft, &&, ||, !, isBlockedRight)
//#-hidden-code

import Document10_Challenge2

playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
let expert = /*#-editable-code*/<#initialize#>/*#-end-editable-code*/
let character = /*#-editable-code*/<#initialize#>/*#-end-editable-code*/
//#-hidden-code
if let expert = expert as? Expert, let character = character as? Character {
    world.place(expert, facing: north, at: Coordinate(column: 4, row: 0))
    world.place(character, facing: west, at: Coordinate(column: 6, row: 2))
}
//#-end-hidden-code
//#-editable-code Enter the rest of your solution here

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

