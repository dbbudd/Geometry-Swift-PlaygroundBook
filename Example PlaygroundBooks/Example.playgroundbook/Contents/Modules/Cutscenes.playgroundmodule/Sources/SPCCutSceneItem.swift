//
//  CutSceneItem.swift
//
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import Foundation

public struct SPCCutSceneItem {
    public let name: String
    public let sourcePath: String
    public let timeline: [(name: String, seconds: Float)]
    public let isOutro: Bool
    public let isSceneBased: Bool
    
    public var fileName: String {
        let components = sourcePath.components(separatedBy: "/")
        let name = components[1].components(separatedBy: ".")
        return name[0]
    }
    
    public var fileExtension: String {
        let components = sourcePath.components(separatedBy: "/")
        let name = components[1].components(separatedBy: ".")
        return name[1]
    }
    
    public var sourceDirectory: String {
        let components = sourcePath.components(separatedBy: "/")
        return components[0] + "/"
    }
    
    public init(name: String, sourcePath: String, timeline: [(name: String, seconds: Float)], isOutro: Bool = false, isSceneBased: Bool = false) {
        self.name = name
        self.sourcePath = sourcePath
        self.timeline = timeline
        self.isOutro = isOutro
        self.isSceneBased = isSceneBased
    }
    
    public func fileURLForSourcePath() -> URL? {
        return Bundle.main.url(forResource: fileName, withExtension: fileExtension, subdirectory: sourceDirectory)
    }
    
    public func fileURLForSourceDirectory() -> URL {
        guard let full = fileURLForSourcePath() else { fatalError("Something went really wrong!!") }
        return full.deletingLastPathComponent()
    }
}
