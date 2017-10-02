// 
//  Assessments.swift
//
//  Copyright (c) 2016 Apple Inc. All Rights Reserved.
//
import PlaygroundSupport
import Foundation

let solution = "rectangle()"
var successMessage = "You have met the minimum requires, check that your image looks as described in the problem."
var failureHints = "FAILURE"


public func findUserCodeInputs(from input: String) -> [String]{
    var inputs: [String] = []
    let scanner = Scanner(string: input)
    var userInput: NSString? = ""
    
    scanner.scanUpTo("//#-editable-code", into: nil)
    scanner.scanUpTo("\n", into: nil)
    scanner.scanUpTo("//#-end-editable-code", into: &userInput)
    
    inputs.append(String(userInput!))

    return inputs
}

public func makeAssessment(of input: String){
    let codeInputs = findUserCodeInputs(from: input)
    
    if codeInputs[0].contains(solution){
        PlaygroundPage.current.assessmentStatus = .pass(message: successMessage)
    }
    else{
        PlaygroundPage.current.assessmentStatus = .fail(hints: [codeInputs[0]], solution: nil)
    }
}
