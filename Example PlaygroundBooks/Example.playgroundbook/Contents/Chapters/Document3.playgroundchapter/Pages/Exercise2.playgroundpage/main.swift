//#-hidden-code
//
//  main.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Use a `for` loop to repeat a sequence of commands.
 
 In this puzzle, you must collect four gems that are located in the same relative locations around a square. You’ll create a [loop](glossary://loop) that repeats the code below for each of the sides to solve the entire puzzle.
 
 1. steps: Select `for` in the shortcut bar to add a `for` loop into your code.
 2. Press the bottom curly brace to select the loop.
 3. Press and hold the curly brace, then drag it downward to pull the existing code into the loop.
*/
//#-hidden-code

import Document3_Exercise2

playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, hide, Page_Contents)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, for, moveForward(), collectGem(), turnRight())
//#-editable-code

moveForward()
collectGem()
moveForward()
moveForward()
moveForward()
turnRight()
//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

