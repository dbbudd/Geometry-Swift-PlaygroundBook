//
//  CameraController.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//
import SceneKit
import UIKit

extension SCNVector4 {
    func length() -> Float {
        return sqrt(x * x + y * y + z * z + w * w)
    }
}

final class CameraController {
    // MARK: Types
    
    enum ViewMode {
        case overhead, poster, movable
    }
    
    static let absoluteFovMax = 140.0
    
    // MARK: Properties
    
    unowned let scnView: SCNView
    
    /// The lowest Fov angle the camera is allowed to reach when zooming (most zoom).
    let minFov: CGFloat
    
    /// The largest Fov angle the camera is allowed to reach when zooming (least zoom).
    let maxFov: CGFloat
    
    let rootHandle = SCNNode()
    
    let camera: SCNCamera
    
    let cameraNode: SCNNode
    
    let originalFov: CGFloat

    let originalEuler: SCNVector3
    let originalRotationInverse: SCNMatrix4

    let originalCameraTransform: SCNMatrix4

    var mode: ViewMode = .movable

    var shouldSuppressGestureControl = false
    
    var yTrackball: Trackball
    var xTrackball: Trackball

    var currentFOV: CGFloat = 0.0

    // MARK: Initialization
 
    /// Registers for camera gesture recognizers.
    init?(view: SCNView) {
        guard let scene = view.scene else { return nil }
        guard let cameraHandle = scene.rootNode.childNode(withName: CameraHandleName, recursively: true) else { return nil }
        guard let cameraNode = scene.rootNode.childNode(withName: CameraNodeName, recursively: true) else { return nil }
        
        self.scnView = view
        self.cameraNode = cameraNode
        self.camera = cameraNode.camera!
        
        // Set the minimum and maximum FOV based on the original camera Fov.
        minFov = camera.fov * 0.5
        
        // The maximum should be constrained to the the `absoluteFovMax` or the camera’s initial Fov.
        let upperLimit = max(camera.fov, CGFloat(CameraController.absoluteFovMax))
        maxFov = min(camera.fov * 1.5, upperLimit)
        
        rootHandle.name = CameraHandleName
        scene.rootNode.addChildNode(rootHandle)
        
        // Put the camera into the rootHandle’s coordinate system
        cameraNode.transform = cameraHandle.convertTransform(cameraNode.transform, to: rootHandle)
        
        // Reparent the camera under the normalized `rootHandle`. 
        rootHandle.addChildNode(cameraNode)
        cameraHandle.removeFromParentNode()
        
        // BIG PICTURE:
        // pull the y axis rotation out of the camera
        // move the camera to zero degrees around the y axis
        // apply the y rotation to the rootHandle
        
        // grab the position
        var position = cameraNode.position
        // project it into the x/z plane
        position.y = 0.0
        // find the angle
        let yRotation = atan2(position.x, position.z)
        
        // move the camera to the zero rotation spot by applying a negative y rotation
        cameraNode.transform = SCNMatrix4Mult(cameraNode.transform, SCNMatrix4MakeRotation(yRotation, 0.0, -1.0, 0.0))
        
        // rotate the rootHandle to the proper y rotation
        rootHandle.eulerAngles.y = yRotation
        
        // Save the initial camera information.
        originalFov = camera.fov
        originalCameraTransform = cameraNode.transform
        originalEuler = SCNVector3(x: asin(sin(rootHandle.eulerAngles.x)), y: asin(sin(rootHandle.eulerAngles.y)), z: asin(sin(rootHandle.eulerAngles.z))) // normalize to -.pi/2 to .pi/2
        rootHandle.eulerAngles = originalEuler // set tot he normalized angles
        originalRotationInverse = SCNMatrix4Invert(rootHandle.transform)
        
        let radius = cameraNode.position.length()
        yTrackball = Trackball(center: scene.rootNode.position, radius: -radius, multiplier: 6.0, inRect: scnView.bounds, transform: rootHandle.transform)
        xTrackball = Trackball(center: scene.rootNode.position, radius: -radius, multiplier: 6.0, inRect: scnView.bounds, transform: rootHandle.transform)
        xTrackball.rotationAxis = .x
        xTrackball.rotateAroundVector = SCNVector3(x: 1.0, y: 0.0, z: 0.0)
        xTrackball.minRotation = -.pi / 12.0
        xTrackball.maxRotation = .pi / 8.0

        self.registerCameraGestureRecognizers()
    }
    
    // MARK: Gesture Recognizers

    func registerCameraGestureRecognizers() {
        scnView.isUserInteractionEnabled = true

// removed as part of the making the live view easier to look at
//        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(resetCameraAction(_:)))
//        doubleTapGesture.numberOfTapsRequired = 2
//        scnView.addGestureRecognizer(doubleTapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panCameraAction(_:)))
        scnView.addGestureRecognizer(panGesture)
        
        let pinchGesture = UIPinchGestureRecognizer(target: self, action: #selector(zoomCameraAction(_:)))
        scnView.addGestureRecognizer(pinchGesture)
    }
    
    // MARK: Flyovers
    
    /// Returns the duration the camera will take during its rotation.
    func performShortestFlyover(toFace direction: SCNFloat, completion: (() -> Void)? = nil) -> Double {
        let deltaRot = angleBetweenCamera(and: direction)
        
        // Adjusts duration per radian rotated.
        let duration = abs(Double(deltaRot)) * 0.55
        performFlyover(withRotation: deltaRot, duration: duration, completion: completion)
        
        return duration
    }
    
    /// Returns the duration and rotation the camera will take during its rotation.
    func performFlyover(toFace direction: SCNFloat, completion: (() -> Void)? = nil) -> (duration: Double, rotation: Float) {
        let deltaRot = angleBetweenCamera(and: direction)
        let longestRot = deltaRot < 0 ? deltaRot + 2 * π : deltaRot - 2 * π
        
        // Adjusts duration per radian rotated.
        let duration = abs(Double(longestRot)) * 0.25
        performFlyover(withRotation: longestRot, duration: duration, completion: completion)
        
        return (duration, longestRot)
    }
    
    func performFlyover(withRotation rotation: SCNFloat, duration: Double, completion: (() -> Void)? = nil) {
        guard mode == .movable else { return }
        
        // SCNAction will rotation through the whole rotation
        let actionY = SCNAction.rotate(by: CGFloat(rotation), around: SCNVector3(0, 1, 0), duration: duration)
        actionY.timingMode = .easeInEaseOut
        rootHandle.runAction(actionY) {
            self.yTrackball.transform = SCNMatrix4Rotate(self.yTrackball.transform, rotation, 0, 1, 0)
            completion?()
        }
    }
    
    // MARK: Camera View Modes
    
    func switchToPosterView() {
        mode = .poster

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0
        
        rootHandle.position.y = 100
        rootHandle.rotation = SCNVector4Zero
        camera.fov = 30
        cameraNode.transform = SCNMatrix4Identity
        
        SCNTransaction.commit()
    }
    
    func switchToOverheadView() {
        mode = .overhead
        
        // goal is a perceived value of xRot = -π/2.0 and yRot = 0.0
        // rootHandle.xrot = -(π/2.0 + cameraNode.eulerAngles.x)
        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.0

        let xAngle = -(π/2.0 + cameraNode.eulerAngles.x)
        let xTransform = SCNMatrix4MakeRotation(xAngle, 1.0, 0.0, 0.0)
        rootHandle.transform = xTransform
        
        SCNTransaction.commit()
    }
    
    // MARK: Camera Adjustments
    
    /// Returns the shortest angle between the camera and the supplied direction.
    func angleBetweenCamera(and direction: SCNFloat) -> SCNFloat {
        // Use the presentation node to ensure the rotation info is up to date with the current animation.
        // The result is often used to intrupt the current animation.
        let delta = direction.capPhase() - (rootHandle.presentation.rotation.y * rootHandle.presentation.rotation.w)
        return atan2(sin(delta), cos(delta))
    }

    func zoomCamera(toFov fov: CGFloat, duration: Double = 1.0, completionHandler: (() -> Void)? = nil) {
        guard let camera = cameraNode.camera else { return }

        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        
        camera.fov = max(min(fov, maxFov), minFov)

        SCNTransaction.completionBlock = completionHandler
        SCNTransaction.commit()
    }
    
    private func adjustCameraPitch(toRadians pitch: Float, duration: Double = 0.4, completionHandler: (() -> Void)? = nil) {
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = duration
        
        // -angle: underworld
        // +angle: above world
        // Control the pitch so it does not pass the zero point of the level.
        rootHandle.eulerAngles.x = pitch //min(max(pitch, -π / 2), -0.2)
        
        SCNTransaction.completionBlock = completionHandler
        SCNTransaction.commit()
    }
    
    /// Adjusts the arc angle for the camera moving around the world.
    private func adjustCameraArc(toRadians arc: Float, duration: Double = 0.4, completionHandler: (() -> Void)? = nil) {
        SCNTransaction.begin()
        SCNTransaction.animationDuration = duration
        
        rootHandle.eulerAngles.y = arc
        
        SCNTransaction.completionBlock = completionHandler
        SCNTransaction.commit()
    }

    func resetFromVoiceOver() {
        guard mode == .overhead else { return }
        mode = .movable
        
        camera.fov = originalFov
        rootHandle.transform = SCNMatrix4Identity
        rootHandle.eulerAngles = originalEuler
        self.yTrackball.transform = self.rootHandle.transform
    }
    
    func calculateTransformBetweenVectors(a: SCNVector4, b: SCNVector4) -> SCNMatrix4 {
        guard a.length() > 0.0 && b.length() > 0.0 else { return SCNMatrix4Identity }
        // the w component is the angle, we’ll deal with that separately
        let left = normalize(Float3(a.x, a.y, a.z))
        let right = normalize(Float3(b.x, b.y, b.z))
        
        let croxx = cross(left, right)
        let sine = length(croxx)
        let cosine = dot(left, right)
        
        
        let v = float3x3(Float3(0.0, croxx.z, -croxx.y), Float3(-croxx.z, 0.0, croxx.x), Float3(croxx.y, -croxx.x, 0.0))
        let v2 = v * v
        let v3 = v2 * ((1.0 - cosine) / (sine * sine))
        let floot = float3x3(Float3(1.0, 0.0, 0.0), Float3(0.0, 1.0, 0.0), Float3(0.0, 0.0, 1.0)) + v + v3

        let vectorAlignment = SCNMatrix4(m11: floot.columns.0.x,
                                         m12: floot.columns.1.x,
                                         m13: floot.columns.2.x, m14: 0.0,
                                         m21: floot.columns.0.y,
                                         m22: floot.columns.1.y,
                                         m23: floot.columns.2.y, m24: 0.0,
                                         m31: floot.columns.0.z,
                                         m32: floot.columns.1.z,
                                         m33: floot.columns.2.z, m34: 0.0,
                                         m41: 0.0, m42: 0.0, m43: 0.0, m44: 1.0)
        let rotationChange = SCNMatrix4MakeRotation((b.w - a.w).capPhase(), b.x, b.y, b.z)
        
        return SCNMatrix4Mult(vectorAlignment, rotationChange)
    }

    func clampToPi(from: Float, to: Float) -> Float {
        var clampedDelta: Float = 0.0
        let delta = to - from
        if abs(delta) < (.pi / 2.0) {
            clampedDelta = delta
        } else {
            if from <= 0.0 {
                let toLeftEdge = -(.pi / 2.0) - from
                let toRightEdge = (.pi / 2.0) - to
                clampedDelta = toLeftEdge - toRightEdge
            } else {
                let toLeftEdge = -(.pi / 2.0) - to
                let toRightEdge = (.pi / 2.0) - from
                clampedDelta = toRightEdge - toLeftEdge
            }
        }
        return clampedDelta
    }
    
    // find shortest distance between from and to on each axis then put
    // the transforms together into a matrix
    func clampEulerAngles(from: SCNVector3, to: SCNVector3) -> SCNMatrix4 {
        let deltaX = clampToPi(from: from.x, to: to.x)
        let deltaY = clampToPi(from: from.y, to: to.y)
        let deltaZ = clampToPi(from: from.z, to: to.z)
        
        let x = SCNMatrix4MakeRotation(deltaX, 1.0, 0.0, 0.0)
        let y = SCNMatrix4MakeRotation(deltaY, 0.0, 1.0, 0.0)
        let z = SCNMatrix4MakeRotation(deltaZ, 0.0, 0.0, 1.0)
        
        let transform = SCNMatrix4Mult(z, SCNMatrix4Mult(y, x))

        return transform
    }
    
    func resetCamera(duration: CFTimeInterval = 1.25, completionBlock: (()->())? = nil ) {
        mode = .movable
        
        SCNTransaction.begin()
        
        SCNTransaction.animationDuration = duration
        SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
        
        camera.fov = originalFov
        
        // Reset the camera, which really only applies if we’ve been generating poster views.
        // The only place the cameraNode’s transform is changed is in the poster view generation (switchToPosterView())
        // The rootHandle’s .y position is also only modified in the switchToPoserView function
        cameraNode.transform = originalCameraTransform
        rootHandle.position.y = 0

        let transform = clampEulerAngles(from: rootHandle.eulerAngles, to:originalEuler)
        rootHandle.transform = SCNMatrix4Mult(transform, rootHandle.transform)

        rootHandle.eulerAngles = originalEuler // transform gets us most of the way there but with rounding and weirdness let’s just set it

        SCNTransaction.completionBlock = {
            if let c = completionBlock {
                c()
            }
        }

        SCNTransaction.commit()
        
        self.yTrackball.reset(with: self.rootHandle.transform)
        self.xTrackball.reset(with: self.rootHandle.transform)
    }
    
    // MARK: Gesture Recognizers
    
    var trackballTransform = SCNMatrix4Identity
    @objc func panCameraAction(_ recognizer: UIPanGestureRecognizer) {
        guard shouldSuppressGestureControl == false else { return }
        switch recognizer.state {
        case .began:
            yTrackball.startingPoint = recognizer.location(in: self.scnView)
            xTrackball.startingPoint = recognizer.location(in: self.scnView)
            
            scnView.prioritizeAnimation()
            
        case .changed:
            let yTransform = yTrackball.transformFor(recognizer.location(in: self.scnView))
            let xTransform = SCNMatrix4Mult(originalRotationInverse, xTrackball.transformFor(recognizer.location(in: self.scnView)))
            SCNTransaction.begin()
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
            rootHandle.transform = SCNMatrix4Mult(xTransform, yTransform)
            SCNTransaction.commit()
            
        case .ended:
            let yTransform = yTrackball.transformFor(recognizer.location(in: self.scnView))
            let xTransform = SCNMatrix4Mult(originalRotationInverse, xTrackball.transformFor(recognizer.location(in: self.scnView)))
            SCNTransaction.begin()
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: .easeOut)
            rootHandle.transform = SCNMatrix4Mult(xTransform, yTransform)
            SCNTransaction.commit()
            yTrackball.finish(recognizer.location(in: self.scnView))
            xTrackball.finish(recognizer.location(in: self.scnView))
            
            scnView.deprioritizeAnimationIfPossible()
            
        default:
            break
        }
    }
    
    @objc func zoomCameraAction(_ recognizer: UIPinchGestureRecognizer) {
        guard shouldSuppressGestureControl == false else { return }
        guard let camera = cameraNode.camera else { return }
        
        switch recognizer.state {
        case .began:
            currentFOV = camera.fov
            scnView.prioritizeAnimation()
            
        case .changed:
            let factor = recognizer.scale
            let fov = currentFOV / factor
            // make sure the scale is reset so if we change directions after
            // zooming past the yFOV we reverse the scale
            if fov > maxFov {
                let scale = fov / maxFov
                recognizer.scale = CGFloat(factor * scale)
            }
            if fov < minFov {
                let scale = fov / minFov
                recognizer.scale = CGFloat(factor * scale)
            }
            // zoomCamera clips yFov to between minFov and maxFov
            zoomCamera(toFov: fov, duration: 0.0)
        
        case .ended:
            scnView.deprioritizeAnimationIfPossible()
        
        default:
            break
        }
    }
    
    @objc func resetCameraAction(_: UITapGestureRecognizer) {
        guard shouldSuppressGestureControl == false else { return }
        resetCamera()
    }
}
