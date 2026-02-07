//#-hidden-code
//
//  main.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** [Call](glossary://call) functions from other functions.
 
Up to now, the [functions](glossary://function) you’ve [defined](glossary://define) have only called existing [commands](glossary://command), such as `moveForward()` and `collectGem()`. It doesn’t have to be this way, though!

The function *`turnAround()`* directs your character to turn around and face the opposite direction. You can call this function inside another function, *`solveStair()`*, and call `solveStair()` in your code to solve bigger parts of the puzzle. 
 
 This process of breaking a larger problem into smaller pieces is called [decomposition](glossary://decomposition).
 
 1. steps: Define the `solveStair()` function, calling `turnAround()` inside of it.
 2. Call `solveStair()` along with the other functions you need.
 3. Solve the puzzle by collecting all four gems.
*/
//#-hidden-code

import Document2_Exercise3

playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, hide, Page_Contents)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, moveForward(), turnLeft(), collectGem(), toggleSwitch(), turnRight(), func)
func turnAround() {
    //#-editable-code
    turnLeft()
    turnLeft()
    //#-end-editable-code
}

func solveStair() {
    //#-editable-code

    //#-end-editable-code
}
//#-editable-code
solveStair()
//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

