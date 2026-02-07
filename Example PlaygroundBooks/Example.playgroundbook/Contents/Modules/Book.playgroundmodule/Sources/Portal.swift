//
//  Portal.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import SceneKit
import Foundation
import PlaygroundSupport

enum PortalShape: String {
    case circle
    case square
    case star
    case triangle
    
    var geometrySCNFileName: String {
        switch  self {
        case .circle:   return "portal_circle_on"
        case .square:   return "portal_square_on"
        case .star:     return "portal_star_on"
        case .triangle: return "portal_triangle_on"
        }
    }
    
    var axDescription: String {
        switch self {
        case .circle:   return NSLocalizedString("circular portal", comment: "AX circular portal description. To be used exclusively in speakableDescription within the Portal class")
        case .square:   return NSLocalizedString("square-shaped portal", comment: "AX square-shaped portal description. To be used exclusively in speakableDescription within the Portal class")
        case .star:     return NSLocalizedString("star-shaped portal", comment: "AX star-shaped portal description. To be used exclusively in speakableDescription within the Portal class")
        case .triangle: return NSLocalizedString("triangular portal", comment: "AX triangular portal description. To be used exclusively in speakableDescription within the Portal class")
        }
    }

    // MARK: Shape vending.
    
    private static let allShapes: [PortalShape] = [.circle, .square, .star, .triangle]

    private static var nextShapeIndex = 0

    static func nextShape() -> PortalShape {
        let shape = PortalShape.allShapes[nextShapeIndex % allShapes.count]
        nextShapeIndex += 1
        return shape
    }

    // MARK: `PlaygroundValue` support.

    var playgroundValue: PlaygroundValue {
        return .string(rawValue)
    }

    init?(playgroundValue: PlaygroundValue) {
        guard case let .string(raw) = playgroundValue else { return nil }
        self.init(rawValue: raw)
    }
}

/// A portal is one of the items that can be placed in the world. It teleports Byte from one place to another, with Byte facing the same direction going in and out.
///
/// - localizationKey: Portal
public final class Portal: Item, NodeConstructible {
    
    // MARK: Static
    
    private static let nodeNamesWithParticleSystem = Set(["portal_particles stars", "portal_particles", "portal_particles ON"])

    static var directory: Asset.Directory {
        return .item(identifier)
    }
    
    static let portalAnimation: CAAnimation = {
        return Asset.animation(named: "portal_animation", in: directory)!
    }()
    
    
    fileprivate static let activeShaderInfo = [
        "dialGEO01_01_poka" : "// modifier\r\nfloat emissionColour = _surface.selfIllumination.x * 0.3;\r\nconst vec4 pulseColour = _surface.multiply + 0.5;\r\nconst vec4 ambientColour = vec4(0.737 , 0.834, 0.980 ,1) * (1.0 - _surface.selfIllumination.x);\r\n\r\nfloat speed = sin(u_time * 3) * 0.5 + 0.5;\r\nvec4 glyphColor = saturate(mix(0.0, pulseColour, _surface.selfIllumination.y * speed) + (_surface.selfIllumination.x * _surface.multiply));\r\nglyphColor *= _surface.selfIllumination.x;\r\n\r\n\r\n_surface.emission =  glyphColor;\r\n_surface.selfIllumination = ambientColour;\r\n_surface.diffuse +=  glyphColor;\r\n\r\n_surface.multiply = vec4(1.0);",
        "dialGEO02_01_poka" : "// modifier\r\nfloat emissionColour = _surface.selfIllumination.x * 0.3;\r\nconst vec4 pulseColour = _surface.multiply + vec4(0.5, 0.5, 0.5, 1.0);\r\nconst vec4 ambientColour = vec4(0.737 , 0.834, 0.98 ,1) * (1.0 - _surface.selfIllumination.x);\r\n\r\nfloat speed = sin((u_time + 0.7) * 3) * 0.5 + 0.5;\r\nvec4 glyphColor = saturate(mix(0.0, pulseColour, _surface.selfIllumination.y * speed) + (_surface.selfIllumination.x * _surface.multiply));\r\nglyphColor *= _surface.selfIllumination.x;\r\n\r\n_surface.diffuse +=  glyphColor;\r\n_surface.emission =  glyphColor;\r\n_surface.selfIllumination = ambientColour;\r\n_surface.multiply = vec4(1.0);",
        "eyeGEO_01_poka" : "// modifier\r\nfloat emissionColour = _surface.selfIllumination.x * 0.3;\r\nconst vec4 pulseColour = _surface.multiply + vec4(0.5, 0.5, 0.5, 1.0);\r\nconst vec4 ambientColour = vec4(0.737 , 0.834, 0.98 ,1) * (1.0 - _surface.selfIllumination.x);\r\n\r\nfloat speed = sin((u_time + 0.5) * 3) * 0.5 + 0.5;\r\nvec4 glyphColor = saturate(mix(0.0, pulseColour, _surface.selfIllumination.y * speed) + (_surface.selfIllumination.x * _surface.multiply));\r\nglyphColor *= _surface.selfIllumination.x;\r\n\r\n_surface.diffuse +=  glyphColor;\r\n_surface.emission =  glyphColor;\r\n_surface.selfIllumination = ambientColour;\r\n_surface.multiply = vec4(1.0);"
    ]
  
    fileprivate static let activeShaderInfoLegacy = [
        "dialGEO01_01_poka" : "// modifier\r\nfloat emissionColour = _surface.emission.x * 0.3;\r\nconst vec4 pulseColour = _surface.multiply + vec4(0.5, 0.5, 0.5, 1.0);\r\nconst vec4 ambientColour = vec4(0.38 , 0.4, 0.5 ,1);\r\n\r\nfloat speed = sin((u_time + 0.5) * 3) * 0.5 + 0.5;\r\nvec4 glyphColor = saturate(mix(0.0, pulseColour, _surface.emission.y * speed) + (_surface.emission.x * _surface.multiply));\r\nglyphColor *= _surface.emission.x;\r\n\r\n_surface.diffuse +=  glyphColor;\r\n_surface.emission =  emissionColour + ambientColour;\r\n\r\n_surface.multiply = vec4(1.0);\r\n",
        "dialGEO02_01_poka" : "// modifier\r\nfloat emissionColour = _surface.emission.x * 0.3;\r\nconst vec4 pulseColour = _surface.multiply + vec4(0.5, 0.5, 0.5, 1.0);\r\nvec4 ambientColour = vec4(0.38 , 0.4, 0.5 ,1);\r\n\r\nfloat speed = sin((u_time + 0.7) * 3) * 0.5 + 0.5;\r\nvec4 glyphColor = saturate(mix(0.0, pulseColour, _surface.emission.y * speed) + (_surface.emission.x * _surface.multiply));\r\nglyphColor *= _surface.emission.x;\r\n\r\n_surface.diffuse +=  glyphColor;\r\n_surface.emission =  ambientColour;\r\n\r\n_surface.multiply = vec4(1.0);",
        "eyeGEO_01_poka" : "// modifier\r\nfloat emissionColour = _surface.emission.x * 0.3;\r\nconst vec4 pulseColour = _surface.multiply + 0.5;\r\nconst vec4 ambientColour = vec4(0.38 , 0.4, 0.5 ,1);\r\n\r\nfloat speed = sin(u_time * 3) * 0.5 + 0.5;\r\nvec4 glyphColor = saturate(mix(0.0, pulseColour, _surface.emission.y * speed) + (_surface.emission.x * _surface.multiply));\r\nglyphColor *= _surface.emission.x;\r\n\r\n_surface.diffuse +=  glyphColor;\r\n_surface.emission =  emissionColour + ambientColour;\r\n\r\n_surface.multiply = vec4(1.0);"
    ]
    
    fileprivate static let inactiveShaderInfo = [
        "dialGEO01_01_poka" : "// modifier\r\nfloat emissionColour = _surface.emission.x * 0.3;\r\nconst vec4 pulseColour = _surface.multiply + vec4(0.5, 0.5, 0.5, 1.0);\r\nconst vec4 ambientColour = vec4(0.38 , 0.4, 0.5 ,1);\r\n\r\nfloat speed = sin((u_time + 0.5) * 3) * 0.5 + 0.5;\r\nvec4 glyphColor = saturate(mix(0.0, pulseColour, _surface.emission.y) + (_surface.emission.x * _surface.multiply));\r\nglyphColor *= _surface.emission.x;\r\n\r\n_surface.diffuse +=  glyphColor;\r\n_surface.emission =  emissionColour + ambientColour;\r\n\r\n_surface.multiply = vec4(1.0);\r\n",
        "dialGEO02_01_poka" : "// modifier\r\nfloat emissionColour = _surface.emission.x * 0.3;\r\nconst vec4 pulseColour = _surface.multiply + vec4(0.5, 0.5, 0.5, 1.0);\r\nvec4 ambientColour = vec4(0.38 , 0.4, 0.5 ,1);\r\n\r\nfloat speed = sin((u_time + 0.7) * 3) * 0.5 + 0.5;\r\nvec4 glyphColor = saturate(mix(0.0, pulseColour, _surface.emission.y) + (_surface.emission.x * _surface.multiply));\r\nglyphColor *= _surface.emission.x;\r\n\r\n_surface.diffuse +=  glyphColor;\r\n_surface.emission =  ambientColour;\r\n\r\n_surface.multiply = vec4(1.0);\r\n",
        "eyeGEO_01_poka" : "float emissionColour = _surface.emission.x * 0.3;\r\nconst vec4 pulseColour = _surface.multiply + 0.5;\r\nconst vec4 ambientColour = vec4(0.38 , 0.4, 0.5 ,1);\r\n\r\nfloat speed = sin(u_time * 3) * 0.5 + 0.5;\r\nvec4 glyphColor = saturate(mix(0.0, pulseColour, _surface.emission.y) + (_surface.emission.x * _surface.multiply));\r\nglyphColor *= _surface.emission.x;\r\n\r\n_surface.diffuse +=  glyphColor;\r\n_surface.emission =  emissionColour + ambientColour;\r\n\r\n_surface.multiply = vec4(1.0);\r\n"
    ]
    
    
    // MARK: Private
    
    private var particlesNode:SCNNode?
    private static let activateEnterKey = "PortalEnter-Key"
    private static let activateExitKey = "PortalExit-Key"
    private static let portalMainSCNFile = "portal_main"
    private static let portalCustomNodeName = "eyeGEO_01_poka" // This is the node to look for in the customized scn files.
    private static let outerGlowNodeName = "OuterGlow"
    private static let dialNodeName = "dialGEO01_01_poka"
    private static let portalParticlesNodeName = "portal_particles"
    
    private var animationNode: SCNNode {
        return scnNode.childNode(withName: "CHARACTER_Portal", recursively: true) ?? scnNode
    }
    
    fileprivate var particleSystemsEnabled: Bool = true {
        didSet {
            guard oldValue != particleSystemsEnabled else { return }
            scnNode.enumerateHierarchy { (node, _) in
                guard let name = node.name, Portal.nodeNamesWithParticleSystem.contains(name) else { return }
                node.isHidden = !isActive
            }
        }
    }
    
    fileprivate enum ShaderMode {
        case active
        case inactive
    }

    fileprivate var shaderMode: ShaderMode = .active {
        didSet {
            guard oldValue != shaderMode else { return }
            let shaderInfo = getShaderInfo()
            let nodeNames = shaderInfo.keys
            scnNode.enumerateHierarchy { (node, _) in
                guard
                    let name = node.name,
                    nodeNames.contains(name),
                    let geometry = node.geometry,
                    var modifierInfo = geometry.shaderModifiers else { return }
                modifierInfo[.surface] = shaderInfo[name]
                geometry.shaderModifiers = modifierInfo
            }
        }
    }

    private var isTerminatingPortal: Bool = false
    // If the Portal is initialized via the public initializer API, it’s being placed in the world atop existing geometry which is now atlased, and needs a vertical displacement.
    private let shouldVerticallyDisplacePosition: Bool
    private let verticalPositionDisplacementValue = Float(0.008)
    
    private var applyColorToNodes:((_ color: UIColor)->())? = nil // a block called everytime color is set. Used to set node material color values.
    
    private(set) var shape: PortalShape? {
        didSet {
            if let linkedPortal = linkedPortal,
                isTerminatingPortal,
                linkedPortal.shape != shape {
                shape = linkedPortal.shape
                return
            }

            setShape()
        }
    }
    
    // MARK: Properties
    
    var linkedPortal: Portal? {
        didSet {
            // Automatically set the reverse link if not the terminating portal.
            guard !isTerminatingPortal, let linkedPortal = linkedPortal else { return }
            linkedPortal.isTerminatingPortal = true
            linkedPortal.linkedPortal = self
            linkedPortal.color = color
            if shape != nil {
                linkedPortal.shape = shape
            }
            scnNode.setName(forCoordinate: linkedPortal.coordinate)
        }
    }
    
    var axDescription: String {
        if let shape = self.shape {
            return shape.axDescription
        }
        else {
            return ""
        }
    }
    
    
    /// Tracks the state of the portal seperate from its animation.
    fileprivate var _isActive = true
    
    /// State of the portal. An active portal transports a character that moves onto it, while an inactive portal does not. Portals are active by default.
    ///
    /// - localizationKey: isActive
    public var isActive: Bool {
        get {
            return _isActive
        }
        set {
            guard _isActive != newValue else { return }
            _isActive = newValue
            
           
            if world?.isAnimated == true {
                let controller = Controller(identifier: id, kind: .activate, state: isActive)
                world?.add(action: .control(controller))
            }
            else {
                setState(isActive, animated: false)
            }
            
            linkedPortal?.isActive = isActive
            
        }
    }

    var color: Color {
        didSet {
            setColor()
        }
    }
    
    // MARK: Item
    
    public static let identifier: WorldNodeIdentifier = .portal
    
    public weak var world: GridWorld?
    
    public let node: NodeWrapper
    
    public var id = Identifier.undefined
    
    
    // MARK: Initialization
    
    /// Creates a portal with the specified color. The portal can then can be placed in the world.
    ///
    /// Example usage:
    /// ````
    /// let portal = Portal(color: .green)
    /// ````
    ///
    /// - Parameter color: The color to use for the portal.
    ///
    /// - localizationKey: Portal(color:)
    public convenience init(color: Color) {
        self.init(color: color, shape: PortalShape.nextShape())
    }

    init(color: Color, shape: PortalShape?) {
        self.color = color
        self.shape = shape
        shouldVerticallyDisplacePosition = true
        self.node = NodeWrapper(identifier: .portal)
    }
    
    init?(node: SCNNode) {
        guard node.identifier == .portal else { return nil }
        self.color = .blue
        shouldVerticallyDisplacePosition = true
        self.node = NodeWrapper(node)
    }
    
    func enter(atSpeed speed: Float = 1.0, actorType: ActorType) {
        let animation = Portal.portalAnimation
        animation.speed = speed
        animation.beginTime = CACurrentMediaTime() + (TimeInterval(1.0 / speed) * actorType.portalEnterDelay)
        animation.startCompletionBlock = { [weak self] in
            self?.triggerArriveParticles()
        }
        animationNode.addAnimation(animation, forKey: Portal.activateEnterKey)
    }
    
    func exit(atSpeed speed: Float = 1.0, actorType: ActorType) {
        let animation = Portal.portalAnimation
        animation.speed = speed
        animation.beginTime = CACurrentMediaTime() + (TimeInterval(1.0 / speed) * actorType.portalExitDelay)
        animation.startCompletionBlock = { [weak self] in
            self?.triggerArriveParticles()
        }
        animationNode.addAnimation(animation, forKey: Portal.activateExitKey)
    }
    
    // MARK: Setters
    
    private func setColor() {
        // The color representing the portal’s active and inactive states.
        let activeColor: Color = isActive ? self.color : .gray
        applyColorToNodes?(activeColor.rawValue)
    }
    
    public func loadGeometry() {
        guard scnNode.childNodes.isEmpty else { return }
        setShape()
        
        if #available(iOS 13.0, *) {
            updateAppearance(traitCollection: UITraitCollection.current)
        }
    }
    
    public func updateAppearance(traitCollection: UITraitCollection) {
        guard #available(iOS 13.0, *) else { return }
        
        if let mat = animationNode.childNode(withName: "floor", recursively: true)?.firstGeometry?.firstMaterial {
            mat.diffuse.updateAppearance(traitCollection: traitCollection)
        }
    }
    
    fileprivate func triggerArriveParticles() {
        guard
            let pSystems = particlesNode?.particleSystems,
            pSystems.count > 0  else { return }
    }
    
    private func getShaderInfo() -> [String:String] {
        if isActive {
            return Portal.activeShaderInfo
        }
        else {
            return  Portal.inactiveShaderInfo
        }
    }
    
    private func setShape() {
        guard let shape = shape else { return }

        for childNode in scnNode.childNodes {
            childNode.removeFromParentNode()
        }
        
        let portalRootNode = Asset.node(named: Portal.portalMainSCNFile, in: .item(.portal), fileExtension: "scn")!
        let shapeSceneRootNode = Asset.node(named: shape.geometrySCNFileName, in: .item(.portal), fileExtension: "scn")!
        let shapeNode = shapeSceneRootNode.childNode(withName: Portal.portalCustomNodeName, recursively: true)!
        
        portalRootNode.addChildNode(shapeNode)
        
        self.applyColorToNodes  =  { appliedColor in
            let ringNode = portalRootNode.childNode(withName: Portal.outerGlowNodeName, recursively: true)!
            let dialNode = portalRootNode.childNode(withName: Portal.dialNodeName, recursively: true)!
            let mainParticlesNode = portalRootNode.childNode(withName: Portal.portalParticlesNodeName, recursively: true)!
            
            shapeNode.geometry?.materials[0].multiply.contents = appliedColor
            ringNode.geometry?.materials[0].multiply.contents = appliedColor
            dialNode.geometry?.materials[0].multiply.contents = appliedColor
            mainParticlesNode.particleSystems?[0].particleColor = appliedColor
        }
        
        portalRootNode.enumerateHierarchy { node, _ in
            node.castsShadow = true
        }
        
        setColor()
        
        if  let linkedPortal = linkedPortal,
            linkedPortal.isTerminatingPortal,
            linkedPortal.shape != shape {
                linkedPortal.shape = shape
        }
        
        if shouldVerticallyDisplacePosition {
            var position = portalRootNode.position
            position.y = verticalPositionDisplacementValue
            portalRootNode.position = position
        }
        self.setColor()
        prepare([portalRootNode, shapeSceneRootNode]) { [unowned self] (successful) in
            DispatchQueue.main.async { [unowned self] in
                SCNTransaction.begin()
                SCNTransaction.animationDuration = 0
                self.scnNode.addChildNode(portalRootNode)
                SCNTransaction.commit()
            }
        }
    }
}

extension Portal: Controllable {
    // MARK: Controllable
    
    @discardableResult
    func setState(_ state: Bool, animated: Bool) -> TimeInterval {
        _isActive = state
        
        let speed = Double(GridWorld.commandSpeed)
        let duration = animated ? 1 / speed : 0
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        setColor()
        particleSystemsEnabled = _isActive
        shaderMode = _isActive ? .active : .inactive
        SCNTransaction.commit()
        
        return duration
    }
}

extension Portal: MessageConstructor {
    // MARK: MessageConstructor
    
    var message: PlaygroundValue {
        return .array(baseMessage + stateInfo)
    }
    
    var stateInfo: [PlaygroundValue] {
        return [.boolean(isActive), color.message, shape!.playgroundValue]
    }
}

extension ActorType {
    
    var portalEnterDelay: TimeInterval {
        return TimeInterval(0.1)
    }
    
    var portalExitDelay: TimeInterval {
        var delay: TimeInterval = 0
        
        switch self {
        case .expert:
            delay = 1.25
        case .byte, .octet:
            delay  = 1.45
        case .blu:
            delay = 1.19
        case .hopper:
            delay = 1.35
        }
        return delay
    }
}

