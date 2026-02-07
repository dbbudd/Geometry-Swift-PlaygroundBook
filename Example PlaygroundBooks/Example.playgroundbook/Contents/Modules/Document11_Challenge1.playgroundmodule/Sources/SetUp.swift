//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "12.2")

public func playgroundPrologue() {
    addGameNodes()
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

func addGameNodes() {
    world.placeGems(at: world.coordinates(inColumns: [1], intersectingRows: 5...8))
    world.placeGems(at: world.coordinates(inColumns: [5], intersectingRows: [1,2,4]))
    world.placeGems(at: world.coordinates(inColumns: [4,5], intersectingRows: [5]))
    
    let lock = PlatformLock(color: .purple)
    world.place(lock, facing: north, at: Coordinate(column: 1, row: 4))
    let platform1 = Platform(onLevel: 3, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 3, row: 5))
    let lock2 = PlatformLock(color: .green)
    world.place(lock2, facing: west, at: Coordinate(column: 6, row: 5))
    let platform2 = Platform(onLevel: 1, controlledBy: lock2)
    world.place(platform2, at: Coordinate(column: 5, row: 3))
}
