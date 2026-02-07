//#-hidden-code
//
//  main.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** [Decompose](glossary://decomposition) a solution across multiple functions.
 
As you’ve just learned, it can be very useful to define a function that accomplishes a small task, then [call](glossary://call) that function within another function to accomplish an even bigger task.
 
This practice makes your code more readable, because you can name a function based on its purpose; for example, `turnAround()`. It also simplifies the process of writing code, because after you’ve written a function to perform a bigger task, you no longer have to think about the individual commands.
 
 1. steps: Run the code to see what happens when `solveRow()` is called.
 2. Tweak the code inside `solveRow()` so that it solves a bigger chunk of the puzzle.
 3. Call `solveRow()` along with other commands to solve the puzzle.
*/
//#-hidden-code

import Document2_Challenge3

playgroundPrologue()
//#-end-hidden-code
//#-code-completion(everything, hide)
//#-code-completion(identifier, hide, Page_Contents)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, moveForward(), turnLeft(), collectGem(), toggleSwitch(), turnRight(), func)
func collectGemTurnAround() {
    //#-editable-code
    moveForward()
    moveForward()
    collectGem()
    turnLeft()
    turnLeft()
    moveForward()
    moveForward()
    //#-end-editable-code
}

func solveRow() {
    //#-editable-code
    collectGemTurnAround()
    
    //#-end-editable-code
}
//#-editable-code
solveRow()
//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

