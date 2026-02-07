//
//  Assessments.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation
import Book

let success = NSLocalizedString("### Well done! \nYou’re figuring this out quickly-keep it up! \n\n[**Next Page**](@next)", comment:"Success message")
var hints = [
    NSLocalizedString("[Initialize](glossary://initialization) your expert using the type name `Expert` followed by `()`.", comment:"Hint"),
    NSLocalizedString("Use [dot notation](glossary://dot%20notation) to code a solution for the rest of the puzzle.", comment:"Hint"),
    NSLocalizedString("This puzzle is a **challenge** and has no provided solution. Strengthen your coding skills by creating your own approach to solving it.", comment:"Hint")


]


let solution: String? = nil

public func assessmentPoint() -> AssessmentResults {
    return updateAssessment(successMessage: success, failureHints: hints, solution: solution)
}
