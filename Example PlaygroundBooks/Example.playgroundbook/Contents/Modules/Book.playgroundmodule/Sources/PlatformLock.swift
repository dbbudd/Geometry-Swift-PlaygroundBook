//
//  PlatformLock.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

/**
 A platform lock moves all instances of type `Platform` associated with the lock either up or down when an instance of type `Expert` calls the `turnLockUp()` or `turnLockDown()` method.
 - localizationKey: PlatformLock
 */
public final class PlatformLock: Item, NodeConstructible {
    // MARK: Static
    
    static let template = Asset.neutralPose(in: .item(.platformLock))!
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .platformLock
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    // MARK: Private
    
    private let basePath: Asset.Directory = .item(.platformLock)
    
    private var keysPath: Asset.Directory {
        return .custom(self.basePath.path + "Keys/")
    }
    
    private var glyphMaterial: SCNMaterial? {
        return scnNode.childNode(withName: "lockAlpha_0001", recursively: true)?.firstGeometry?.firstMaterial
    }
    
    private var keysNode: SCNNode? {
        return scnNode.childNode(withName: "Keys", recursively: true)
    }
    
    private var keysMaterial: SCNMaterial? {
        return self.keysNode?.firstGeometry?.firstMaterial
    }
    
    public var color: Color {
        didSet {
            setColor()
        }
    }
    
    fileprivate(set) var platforms = Set<Platform>()
    
    /// Creates a platform lock with the specified color. The platform lock can then can be placed in the world.
    ///
    /// Example usage:
    /// ````
    /// let lock = PlatformLock(color: .green)
    /// ````
    ///
    /// - Parameter color: The color of the platform lock.
    ///
    /// - localizationKey: PlatformLock(color:)
    public init(color: Color = .yellow) {
        self.color = color
        node = NodeWrapper(identifier: .platformLock)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .platformLock else { return nil }
        self.color = .yellow
        self.node = NodeWrapper(node)
    }
    
    func add(_ platform: Platform) {
        platforms.insert(platform)
        
        animateInKey(index: platforms.count)
    }
    
    // MARK: Platform Movement
    
    /// Adds a command to move the platforms.
    public func movePlatforms(up: Bool, numberOfTimes: Int = 1) {
        let controller = Controller(identifier: id, kind: .movePlatforms, state: up)
        for _ in 1...numberOfTimes {
            // If moving the platforms down, make sure that it’s possible before
            // adding a command.
            guard up || (!up && canLowerPlatforms()) else { return }

            world?.add(action: .control(controller))
        }
    }
    
    func canLowerPlatforms() -> Bool {
        return platforms.reduce(true) { all, platform in
            return all && platform.isLowerable
        }
    }
    
    /// Performs the action to move the platforms.
    func performPlatformMovement(goingUp: Bool, duration: TimeInterval = 0) {
        if goingUp {
            raisePlatforms(duration: duration)
        }
        else {
            lowerPlatforms(duration: duration)
        }
    }
    
    func raisePlatforms(duration: TimeInterval = 0) {
        for platform in platforms {
            platform.raise(over: duration)
        }
    }
    
    @discardableResult
    func lowerPlatforms(duration: TimeInterval = 0) -> Bool {
        var didMovePlatform = true
        for platform in platforms {
            didMovePlatform = didMovePlatform && platform.lower(over: duration)
        }
        
        return didMovePlatform
    }
    
    /// Animates in the lock keys that are shown. 
    func animateInKey(index: Int) {
        let name = "LockKeys0\(index % 5)"
        guard let animation = Asset.animation(named: name, in: keysPath) else { return }
        
        keysNode?.addAnimation(animation, forKey: name)
    }
    
    func setColor() {
        glyphMaterial?.diffuse.contents = color.rawValue
        keysMaterial?.diffuse.contents = color.rawValue
        
        for platform in platforms {
            platform.setColor()
        }
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        
        let baseNode = Asset.neutralPose(in: basePath, fileExtension: "scn")!
        scnNode.addChildNode(baseNode)
        
        let keys = Asset.neutralPose(in: keysPath, fileExtension: "scn")!
        keys.name = "Keys"
        scnNode.addChildNode(keys)
        
        // Add a key for every attached platform.
        if !platforms.isEmpty {
            for i in 1...platforms.count {
                animateInKey(index: i)
            }
        }
        
        if #available(iOS 13.0, *) {
            updateAppearance(traitCollection: UITraitCollection.current)
        }
        
        setColor()
    }
    
    public func updateAppearance(traitCollection: UITraitCollection) {
        guard #available(iOS 13.0, *) else { return }
        
        glyphMaterial?.transparent.updateAppearance(traitCollection: traitCollection)
        
        if let mat = scnNode.childNode(withName: "zon_prop_lockStatue_a_GEO_0000", recursively: true)?.firstGeometry?.firstMaterial {
            mat.diffuse.updateAppearance(traitCollection: traitCollection)
        }
        
        if let mat = scnNode.childNode(withName: "zon_prop_lockStatue_a_GEO_0001", recursively: true)?.firstGeometry?.firstMaterial {
            mat.diffuse.updateAppearance(traitCollection: traitCollection)
        }
    }
}

extension PlatformLock: Controllable {
    // MARK: Controllable
    
    @discardableResult
    func setState(_ state: Bool, animated: Bool) -> TimeInterval {
        let duration: TimeInterval = animated ? TimeInterval(1 / GridWorld.commandSpeed) : 0
        performPlatformMovement(goingUp: state, duration: duration)
        
        return duration
    }
}

extension PlatformLock: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        let platformIndicies = platforms.map {
            PlaygroundValue.integer($0.id)
        }
        
        return [color.message, .array(platformIndicies)]
    }
}

