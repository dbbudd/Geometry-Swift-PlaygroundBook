//#-hidden-code
//
//  main.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Find the bugs and fix them.
 
 When you write code, it’s easy to make mistakes. A mistake that keeps your program from running correctly is called a [bug](glossary://bug), and finding and fixing bugs is called [debugging](glossary://debug).
 
 The code below contains one or more bugs. To debug it, rearrange the commands into the right order to solve the puzzle.
 
 1. steps: Run the code to see where the mistake occurs.
 2. Identify the command that’s in the wrong place, then press the command to select it.
 3. Drag the command to the correct location, then run the code again to test it.
*/
//#-hidden-code

import Document1_Exercise4

playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, hide, Page_Contents)
//#-code-completion(identifier, show, moveForward(), turnLeft(), collectGem(), toggleSwitch())
//#-editable-code
moveForward()
turnLeft()
moveForward()
moveForward()
collectGem()
moveForward()
toggleSwitch()
//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

