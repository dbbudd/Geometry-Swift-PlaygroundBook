//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "9.3")
let actor = Actor()

public var finalGemCount = 0
public var randomGemCount = 0

public func playgroundPrologue() {
    
    let itemCoordinates = [
                              Coordinate(column: 3, row: 2),
                              Coordinate(column: 3, row: 3),
                              Coordinate(column: 3, row: 4),
                              Coordinate(column: 3, row: 6),
                              Coordinate(column: 1, row: 2),
                              Coordinate(column: 1, row: 3),
                              Coordinate(column: 1, row: 5),
                              Coordinate(column: 1, row: 6),
                              Coordinate(column: 3, row: 0),
                              Coordinate(column: 2, row: 0),
                              Coordinate(column: 1, row: 0),
                              
                              ]
    
    placeRandomItems(itemCoordinates: itemCoordinates)
    placeActor()
    
    let handler = assessment(world.collectedGemsAndUserVariablesAreCorrectlyAssigned(userVariableValues: (finalGemCount, randomGemCount), expectedVariableValues: (randomGemCount,randomGemCount)))
 
    world.successCriteria = .custom(.allGoals, handler)
    
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomItems(itemCoordinates: itemCoordinates)
    }
    //// ----
}

// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

func placeActor() {
    world.place(actor, facing: south, at: Coordinate(column: 3, row: 7))
}

func placeRandomItems(itemCoordinates: [Coordinate]) {
    let gem = Gem()
    for coord in itemCoordinates {
        world.place(RandomNode(resembling: gem), at: coord)
    }
}

func realizeRandomItems(itemCoordinates: [Coordinate]) {
    for coor in itemCoordinates {
        if arc4random_uniform(6) % 2 == 0 {
            world.place(Gem(), at: coor)
            randomGemCount += 1
        }
    }
}
