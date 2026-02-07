//
//  LiveView.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Book
import Document1_Exercise1

// Indicate that this is the LiveView process.
Process.configureForAlwaysOnLiveView()

// Load the scene and add any additional elements.
playgroundPrologue()

// Set up the initial SceneController. Another world instances will be created
// for calculations. 
presentWorld()

// Start running the LiveView. 
startPlayback()
