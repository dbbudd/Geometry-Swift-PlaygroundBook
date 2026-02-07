//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "11.2")

public func playgroundPrologue() {
    world.successCriteria = .count(collectedGems: 6, openSwitches: 0)

    addGameNodes()
    placeStartMarker()
    
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
    world.placeGems(at: [Coordinate(column: 1, row: 5), Coordinate(column: 3, row: 7), Coordinate(column: 5, row: 5), Coordinate(column: 1, row: 2), Coordinate(column: 3, row: 0), Coordinate(column: 5, row: 2)])
    
    let lock = PlatformLock()
    world.place(lock, facing: west, at: Coordinate(column: 6, row: 2))
    let platform1 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 3, row: 4))
    let platform2 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 3, row: 5))
    let platform3 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform3, at: Coordinate(column: 2, row: 5))
    let platform4 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform4, at: Coordinate(column: 4, row: 5))
    let platform5 = Platform(onLevel: 4, controlledBy: lock)
    world.place(platform5, at: Coordinate(column: 3, row: 7))
}

func placeStartMarker() {
    let marker = StartMarker(type: .expert)
    world.place(marker, facing: west, at: Coordinate(column: 3, row: 2))
}
