//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "12.7")
public func playgroundPrologue() {

    placeItems()
    placePortals()
    Display.coordinateMarkers = true
    
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world)
    //// ----
}

public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

// MARK: Placement
    
func placeItems() {
    world.placeGems(at: [Coordinate(column: 1, row: 1)])
    world.placeGems(at: [Coordinate(column: 1, row: 6)])
    world.placeGems(at: [Coordinate(column: 6, row: 1)])
    let topLock = PlatformLock(color: .red)
    world.place(topLock, facing: west, at: Coordinate(column: 3, row: 6))
    let platform1 = Platform(onLevel: 1, controlledBy: topLock)
    world.place(platform1, at: Coordinate(column: 2, row: 2))
    
    let lowerLock = PlatformLock(color: .blue)
    world.place(lowerLock, facing: west, at: Coordinate(column: 3, row: 1))
    let platform2 = Platform(onLevel: 1, controlledBy: lowerLock)
    world.place(platform2, at: Coordinate(column: 6, row: 2))
}
    
func placePortals() {

    world.place(Portal(color: .blue), between: Coordinate(column: 2, row: 0), and: Coordinate(column: 6, row: 6))
}
