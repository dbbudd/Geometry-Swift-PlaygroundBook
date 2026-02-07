//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "5.2")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeActor()
    placeRandomItems()

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomItems()
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
    world.place(actor, facing: south, at: Coordinate(column: 2, row: 3))
}

func placeRandomItems() {
    let itemCoordinates = [
                              Coordinate(column: 2, row: 1),
                              Coordinate(column: 2, row: 2),
                              
                              ]
    let gem = Gem()
    let switchItem = Switch()
    for coord in itemCoordinates {
        world.place(RandomNode(resembling: gem), at: coord)
        world.place(RandomNode(resembling: switchItem), at: coord)
    }
}

func realizeRandomItems() {
    let itemCoordinates = [
                              Coordinate(column: 2, row: 1),
                              Coordinate(column: 2, row: 2)
                              ]
    for coor in itemCoordinates {
        if arc4random_uniform(6) % 2 == 0 {
            world.placeGems(at: [coor])
        } else {
            world.place(nodeOfType: Switch.self, at: [coor])
        }
    }
}
