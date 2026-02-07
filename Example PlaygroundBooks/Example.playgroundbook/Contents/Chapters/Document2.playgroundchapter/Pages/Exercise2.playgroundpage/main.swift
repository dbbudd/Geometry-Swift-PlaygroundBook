//#-hidden-code
//
//  main.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
//#-end-hidden-code
/*:#localized(key: "FirstProseBlock")
 **Goal:** Define and use your own function to turn right.
 
In the previous puzzle, you turned right only once, so using three left turns wasn’t a problem. But what if you need to turn right more than once? It would be more efficient to put all those left turns into a ``turnRight()`` command that you run multiple times.

Commands like ``turnRight()`` are actually [functions](glossary://function) that perform a body of work. You’ve already been using functions—every [command](glossary://command) you’ve used to this point has actually been a function that we’ve provided for you.
 
To [define](glossary://define) a function, enter a set of commands between the `{` and `}` curly braces to give it its behavior.

 1. steps: Select the inside of the function body (between the `{` and `}` curly braces).
 2. Enter three `turnLeft()` commands. 
 3. Beneath the function, use existing commands along with `turnRight()` to toggle open the closed switch.
*/
//#-hidden-code

import Document2_Exercise2

playgroundPrologue()
//#-code-completion(everything, hide)
//#-code-completion(identifier, hide, Page_Contents)
//#-code-completion(currentmodule, show)
//#-code-completion(identifier, show, moveForward(), turnLeft(), collectGem(), toggleSwitch())
//#-end-hidden-code
func turnRight() {
    //#-editable-code Add commands to your function
    
    //#-end-editable-code
}
//#-editable-code

//#-end-editable-code
//#-hidden-code
playgroundEpilogue()
//#-end-hidden-code

