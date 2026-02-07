//#-hidden-code
//
//  main.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
**Challenge:** Collect a randomly determined number of gems, represented by `totalGems`.
 
In this challenge, gems appear in random locations and at random times. You’ll need to write an [algorithm](glossary://algorithm) that keeps your character moving efficiently around the puzzle world, picking up any gems that appear.
 
In addition to making your character move efficiently, think about how you can also make your code efficient. Try to break down behaviors into [reusable](glossary://reusability) functions so you need fewer lines of code. This is called **factoring** your code, and it’s not just great for reusing functions. It also makes it easier for anyone looking at your code to figure out what’s going on.
*/
//#-hidden-code

import Document9_Challenge3

playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, hide, Page_Contents)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, isOnOpenSwitch, if, func, for, while, moveForward(), turnLeft(), turnRight(), collectGem(), toggleSwitch(), isOnGem, isOnClosedSwitch, var, ., =, <, >, ==, !=, +=, +, -, isActive, true, false, isBlocked, true, false, isBlockedLeft, &&, ||, !, 0, isBlockedRight, pinkPortal, bluePortal)
//#-editable-code
let totalGems = randomNumberOfGems

//#-end-editable-code


//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

