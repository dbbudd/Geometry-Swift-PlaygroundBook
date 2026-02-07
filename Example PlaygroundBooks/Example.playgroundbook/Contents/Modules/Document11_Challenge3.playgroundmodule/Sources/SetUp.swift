//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
public let world = loadGridWorld(named: "12.4")
var gemRandomizer: RandomizedQueueObserver?
public let randomNumberOfGems = Int(arc4random_uniform(12)) + 1
public var gemsPlaced = 0

let gemCoords = [
    Coordinate(column: 2, row: 0),
    Coordinate(column: 2, row: 2),
    Coordinate(column: 2, row: 3),
    Coordinate(column: 2, row: 5),
    
    Coordinate(column: 4, row: 4),
    Coordinate(column: 4, row: 2),
    Coordinate(column: 4, row: 1),
    
    Coordinate(column: 3, row: 0),
    Coordinate(column: 3, row: 6),
]

public func playgroundPrologue() {
    world.successCriteria = .count(collectedGems: randomNumberOfGems, openSwitches: 0)
    Display.coordinateMarkers = true


    placeRandomItems(gemCoords: gemCoords)
    placeLocks()
    
    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomGems(gemCoords: gemCoords)
    }
    //// ----
    
    placeGemsOverTime()
}

public func presentWorld() {
    setUpLiveViewWith(world)
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

// MARK: Placement

func placeLocks() {
    let lock = PlatformLock(color: .blue)
    world.place(lock, facing: south, at: Coordinate(column: 0, row: 5))
    
    let platform1 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform1, at: Coordinate(column: 3, row: 0))
    
    let platform2 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform2, at: Coordinate(column: 3, row: 1))
    let platform3 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform3, at: Coordinate(column: 3, row: 2))
    let platform4 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform4, at: Coordinate(column: 3, row: 3))
    let platform5 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform5, at: Coordinate(column: 3, row: 4))
    let platform6 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform6, at: Coordinate(column: 3, row: 5))
    let platform7 = Platform(onLevel: 1, controlledBy: lock)
    world.place(platform7, at: Coordinate(column: 3, row: 6))
}

func placeRandomItems(gemCoords: [Coordinate]) {
    let gem = Gem()
    for coordinate in gemCoords {
        world.place(RandomNode(resembling: gem), at: coordinate)
    }
}

func realizeRandomGems(gemCoords: [Coordinate]) {
    
    for coordinate in gemCoords where gemsPlaced < randomNumberOfGems {
        let random = Int(arc4random_uniform(5))
        if random % 2 == 0 {
            world.place(Gem(), at: coordinate)
            gemsPlaced += 1
        }
    }
}

func placeGemsOverTime() {

    gemRandomizer = RandomizedQueueObserver(randomRange: 0...5, world: world) { world in
        let existingGemCount = world.existingGems(at: gemCoords).count
        guard existingGemCount < 3 && gemsPlaced < randomNumberOfGems else { return }
        
        for coordinate in Set(gemCoords) {
            if world.existingGems(at: [coordinate]).isEmpty && world.existingCharacters(at: [coordinate]).isEmpty {
                world.place(Gem(), at: coordinate)
                gemsPlaced += 1
                return
                
            }
        }
    }
}
