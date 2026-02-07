//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "5.3")
public let actor = Actor()

public func playgroundPrologue() {
    
    let itemCoordinates = world.coordinates(inColumns: 2...6, intersectingRows:  [1, 3])
    
    placeActor()
    placeItems()
    placePortals()
    placeRandomItems(itemCoordinates: itemCoordinates)

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
    world.place(actor, facing: west, at: Coordinate(column: 7, row: 3))
}

func placeItems() {
    world.place(Gem(), at: Coordinate(column: 1, row: 1))
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 1, row: 3), and: Coordinate(column: 7, row: 1))
}

func placeRandomItems(itemCoordinates: [Coordinate]) {
    let gem = Gem()
    let switchItem = Switch()
    
    for coord in itemCoordinates {
        world.place(RandomNode(resembling: gem), at: coord)
        world.place(RandomNode(resembling: switchItem), at: coord)
    }
}

func realizeRandomItems(itemCoordinates: [Coordinate]) {
    world.placeRandomGemOrSwitch(at: itemCoordinates)
}
