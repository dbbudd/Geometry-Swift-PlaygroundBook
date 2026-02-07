//
//  SetUp.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import Foundation
import Book

// MARK: Globals
//let world = GridWorld(columns: 6, rows: 5)
let world = loadGridWorld(named: "9.8")
let actor = Actor()
public var gemsPlaced = 0


var gemRandomizer: RandomizedQueueObserver?
public let randomNumberOfGems = Int(arc4random_uniform(12)) + 1

public func playgroundPrologue() {
    world.successCriteria = .count(collectedGems: randomNumberOfGems, openSwitches: 0)
    
    addRandomIndicators()
    
    world.place(Portal(color: .blue), between: Coordinate(column: 2, row: 4), and: Coordinate(column: 3, row: 0))
    
    world.place(actor, facing: north, at: Coordinate(column: 1, row: 0))

    // Must be called in `playgroundPrologue()` to update with the current page contents.
    registerAssessment(world, assessment: assessmentPoint)
    
    //// ----
    // Any items added or removed after this call will be animated.
    finalizeWorldBuilding(for: world) {
        realizeRandomGems()
    }
    //// ----


    placeGemsOverTime()
}

// Called from LiveView.swift to initially set the LiveView.
public func presentWorld() {
    setUpLiveViewWith(world)
    
}

// MARK: Epilogue

public func playgroundEpilogue() {
    sendCommands(for: world)
}

func addRandomIndicators() {
    let itemCoordinates = world.coordinates(inColumns:[1,4])
    for coordinate in itemCoordinates {
        world.place(RandomNode(resembling: Gem()), at: coordinate)
    }
}


func realizeRandomGems() {

    let coordinates = world.coordinates(inColumns: [1,4], intersectingRows: [1,2,3])
    for coordinate in coordinates where gemsPlaced < randomNumberOfGems {
        let random = Int(arc4random_uniform(5))
        if random % 2 == 0 {
            world.place(Gem(), at: coordinate)
            gemsPlaced += 1
        }
    }
}

func placeGemsOverTime() {

    gemRandomizer = RandomizedQueueObserver(randomRange: 0...5, world: world) { world in
        let existingGemCount = world.existingGems(at: world.coordinates(inColumns: [1,4], intersectingRows: [1,2,3])).count
        guard existingGemCount < 3 && gemsPlaced < randomNumberOfGems else { return }
        for coordinate in Set(world.coordinates(inColumns: [1,4], intersectingRows: [1,2,3])) {
            if world.existingGems(at: [coordinate]).isEmpty && world.existingCharacters(at: [coordinate]).isEmpty {
                world.place(Gem(), at: coordinate)
                gemsPlaced += 1
                return
                
            }
        }
    }
}



