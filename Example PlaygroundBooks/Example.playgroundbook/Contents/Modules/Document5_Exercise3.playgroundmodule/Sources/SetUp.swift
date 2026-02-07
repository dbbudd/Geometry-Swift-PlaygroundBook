//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
let world = loadGridWorld(named: "6.4")
public let actor = Actor()

public func playgroundPrologue() {
    
    placeItems()
    placeActor()
    placeWalls()
    placePortals()
    

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
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
    world.place(actor, facing: east, at: Coordinate(column: 0, row: 3))
}

func placeItems() {
    world.place(Gem(), at: Coordinate(column: 6, row: 2))
}

func placePortals() {
    world.place(Portal(color: .blue), between: Coordinate(column: 0, row: 1), and: Coordinate(column: 7, row: 1))
}

func placeWalls() {
    world.place(Wall(edges: [.top, .bottom, .left]), at: Coordinate(column: 6, row: 2))
    world.place(Wall(edges: [.bottom]), at: Coordinate(column: 7, row: 2))
}
