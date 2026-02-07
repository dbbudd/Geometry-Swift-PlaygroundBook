//#-hidden-code
//
//  main.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
**Challenge:** Use all of your coding skills to collect a randomly determined number of gems, represented by `totalGems`.
 
Test your knowledge of [parameters](glossary://parameter), [initialization](glossary://initialization), [methods](glossary://method), [variables](glossary://variable), and more in this challenge! As you go through the puzzle world collecting gems, more will randomly appear. Your goal is to stop collecting gems when you’ve gathered a number equal to the number you specified in `totalGems`.
*/
//#-code-completion(everything, hide)
//#-code-completion(identifier, hide, Page_Contents)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, Expert, Character, (, ), (), turnLockUp(), turnLockDown(), isOnClosedSwitch, var, let, ., =, <, >, ==, !=, +=, +, -, isBlocked, move(distance:), world, place(_:facing:atColumn:row:), true, false, turnLock(up:numberOfTimes:), world, place(_:facing:atColumn:row:), place(_:atColumn:row:), north, south, east, west, isBlockedLeft, &&, ||, 0, !, isBlockedRight, jump())
//#-hidden-code

import Document11_Challenge3

playgroundPrologue()
typealias Character = Actor
//#-end-hidden-code
let totalGems = randomNumberOfGems
//#-editable-code

//#-end-editable-code


//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

