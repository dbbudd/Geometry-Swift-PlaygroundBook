//
//  Platform.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import SceneKit
import PlaygroundSupport

/**
 The type representing a platform that can be moved up or down using a lock.
 - localizationKey: Platform
 */
public final class Platform: Item, NodeConstructible {
    // MARK: Static
    
    static let template: SCNNode = {
        let node = Asset.node(named: "zon_prop_platform_a", in: .item(.platform), fileExtension: "scn")!
        // Offset in the container so that the platform top is level with the y position of the node.
        node.position.y = -WorldConfiguration.levelHeight
        
        return node
    }()
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .platform
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    public var isStackable: Bool {
        return true
    }
    
    public var verticalOffset: SCNFloat {
        let baseHeight = SCNFloat(startingLevel) * WorldConfiguration.levelHeight
        
        // Offset by the `levelHeight` so 0 sits at water level.
        let waterHeight = baseHeight - WorldConfiguration.levelHeight
        
        // Add a vertical offset to avoid fighting with the water.
        return waterHeight + WorldConfiguration.yOffset
    }
    
    var glyphNode: SCNNode? {
        return scnNode.childNode(withName: "zon_prop_platformSign_a_GEO", recursively: true)
    }
    
    private var glyphMaterial: SCNMaterial? {
        return glyphNode?.geometry?.firstMaterial
    }
    
    // MARK: Properties
    
    let startingLevel: Int
    
    var color: Color? {
        didSet {
            setColor()
        }
    }
    
    var isLowerable: Bool {
        let stackingItems = world?.existingItems(at: coordinate).filter {
            return $0.isStackable
        } ?? []
        
        // Do not lower the platform if there is a block or other "stackable" item
        // directly below it.
        return !stackingItems.contains(where: { $0.height == height - 1 })
    }
    
    public weak var lock: PlatformLock? = nil {
        didSet {
            guard let lock = lock else { return }
            
            // Configure the reverse connection to the lock.
            lock.add(self)
            
            setColor()
        }
    }
    
    /**
     Creates a platform on the specified level with the specified platform lock. The platform can then be placed in the world.
     - parameters:
         - onLevel: The level above the floor the platform should start on. If left out, the level is 2.
         - controlledBy: The platform lock that controls the platform.
     - localizationKey: Platform(onLevel:controlledBy:)
     */
    public convenience init(onLevel level: Int = 2, controlledBy lock: PlatformLock) {
        self.init(onLevel: level)
        
        self.lock = lock

        // Configure the reverse connection.
        lock.add(self)
    }
    
    /**
    Creates a platform on the specified level. The platform can then be placed in the world.
     - parameters:
         - onLevel: The level above the floor the platform should start on. If left out, the level is 2.
     - localizationKey: Platform(onLevel:)
    */
    public init(onLevel level: Int = 2) {
        self.startingLevel = max(level, 0)
        node = NodeWrapper(identifier: .platform)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .platform else { return nil }
        self.startingLevel = Int(round(node.position.y / WorldConfiguration.levelHeight))
        
        self.node = NodeWrapper(node)
    }
    
    // MARK: Methods
    
    func raise(over duration: TimeInterval = 0) {
        animateMovement(duration: duration, up: true)
    }
    
    func lower(over duration: TimeInterval = 0) -> Bool {
        guard isLowerable else { return false }
        
        animateMovement(duration: duration, up: false)
        
        // Successfully able to move the platform down.
        return true
    }
    
    private func animateMovement(duration: TimeInterval, up: Bool) {
        guard let world = world else { return }
        let sign: SCNFloat = up ? 1 : -1
        let displacement = sign * WorldConfiguration.levelHeight
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        
        // Move "stackable" items stacked on top of the platform.
        for item in world.existingItems(at: coordinate) where item.isStackable {
            if item.height > height {
                item.position.y += displacement
            }
        }
        
        // Displace the platform.
        position.y += displacement
        
        // Move other the items on top of the platform.
        world.percolateNodes(at: coordinate)

        SCNTransaction.commit()
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        
        let child = Platform.template.clone()
        scnNode.addChildNode(child)
        
        if #available(iOS 13.0, *) {
            updateAppearance(traitCollection: UITraitCollection.current)
        }
        
        // Create a copy of the underlying material so the color is not shared.
        let geoCopy = self.glyphNode?.createUniqueFirstGeometry()
        let materialCopy = geoCopy?.firstMaterial?.copy() as? SCNMaterial
        geoCopy?.firstMaterial = materialCopy
        self.glyphNode?.geometry = geoCopy
        
        setColor()
    }
    
    public func updateAppearance(traitCollection: UITraitCollection) {
        guard #available(iOS 13.0, *) else { return }
        
        if let mat = scnNode.childNode(withName: "zon_prop_platform_a_GEO", recursively: true)?.firstGeometry?.firstMaterial {
            mat.diffuse.updateAppearance(traitCollection: traitCollection)
        }
    }

    /// Grabs the color from the current lock.
    func setColor() {
        glyphMaterial?.diffuse.contents = color?.rawValue ?? lock?.color.rawValue
        
        // Remove shadows for children.
        glyphNode?.castsShadow = false
    }
}

extension Platform: Hashable {
    public func hash(into hasher: inout Hasher) {
        scnNode.hash(into: &hasher)
    }
}

public func ==(lhs: Platform, rhs: Platform) -> Bool {
    return lhs.scnNode === rhs.scnNode
}

extension Platform: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        let index = lock?.id ?? Identifier.undefined
        return [.integer(startingLevel), .integer(index)]
    }
}
