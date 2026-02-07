//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "5.5")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeRandomElements()
    placeActor()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomElements()
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


func placeRandomElements() {
    let itemCoordinates = [
        Coordinate(column: 3, row: 0),
        Coordinate(column: 5, row: 0),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 1, row: 2),
        Coordinate(column: 3, row: 3),
        Coordinate(column: 5, row: 3),
                              ]
    let gem = Gem()
    let switchItem = Switch()
    for coord in itemCoordinates {
        world.place(RandomNode(resembling: gem), at: coord)
        world.place(RandomNode(resembling: switchItem), at: coord)
    }
}

func realizeRandomElements() {
    let itemCoordinates = [
        Coordinate(column: 3, row: 0),
        Coordinate(column: 5, row: 0),
        Coordinate(column: 3, row: 2),
        Coordinate(column: 1, row: 2),
        Coordinate(column: 3, row: 3),
        Coordinate(column: 5, row: 3),
    ]
    
    world.placeRandomGemOrSwitch(at: itemCoordinates)
}

func placeActor() {
    world.place(actor, facing: east, at: Coordinate(column: 1, row: 0))
}
