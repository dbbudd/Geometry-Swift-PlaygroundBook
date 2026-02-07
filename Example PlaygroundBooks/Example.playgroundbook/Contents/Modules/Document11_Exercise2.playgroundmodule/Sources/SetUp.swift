//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "12.6")


public func playgroundPrologue() {
    
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

// MARK: Placement

func addGameNodes() {
    let gems = [
                   Coordinate(column: 3, row: 0),
                   
                   Coordinate(column: 4, row: 0),
                   
                   Coordinate(column: 3, row: 3),
                   
                   
    ]
    world.placeGems(at: gems)
    
    let lock = PlatformLock(color: .purple)
    world.place(lock, facing: north, at: Coordinate(column: 0, row: 0))
    let platform1 = Platform(onLevel: 2, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 3, row: 2))
    let platform2 = Platform(onLevel: 2, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 4, row: 2))
    
    let lock2 = PlatformLock(color: .yellow)
    world.place(lock2, facing: south, at: Coordinate(column: 0, row: 2))
    let platform3 = Platform(onLevel: 2, controlledBy: lock2)
    world.place(platform3, at: Coordinate(column: 3, row: 1))
    let platform4 = Platform(onLevel: 2, controlledBy: lock2)
    world.place(platform4, at: Coordinate(column: 4, row: 1))
}

func placeStartMarker() {
    let expertMarker = StartMarker(type: .expert)
    let characterMarker = StartMarker(type: .byte)

    world.place(characterMarker, facing: south, at: Coordinate(column: 4, row: 3))
    world.place(expertMarker, facing: north, at: Coordinate(column: 0, row: 1))
}

