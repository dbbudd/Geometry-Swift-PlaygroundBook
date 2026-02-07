//
//  SceneController+Controls.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import PlaygroundSupport
import SceneKit

/// An indication that the conforming type functions as a control element in the 
/// `SceneController`.
protocol WorldControl {}

// Retroactively model views within the `SceneController` that function as controls
// as `WorldViewControl`s.
extension UIButton: WorldControl {}
extension GoalCounter: WorldControl {}

// Magic color
public let AppTintColor = Color(red: 254.0/255.0, green: 75.0/255.0, blue: 38.0/255.0, alpha: 1.0)

extension SceneController: PlaygroundLiveViewSafeAreaContainer {
    // MARK: Overlay view
    
    private class OverlayView: UIView, WorldControl {
        
        init() {
            let blurEffect = UIBlurEffect(style: .extraLight)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            if #available(iOS 13.0, *) {
                blurEffectView.effect = UIBlurEffect(style: .systemMaterial)
            }
            blurEffectView.layer.cornerRadius = 22
            blurEffectView.clipsToBounds = true
            blurEffectView.translatesAutoresizingMaskIntoConstraints = true
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            
            super.init(frame: CGRect.zero)
            
            addSubview(blurEffectView)
            blurEffectView.frame = bounds
            
            let whiteOverBlurView = UIView()
            whiteOverBlurView.translatesAutoresizingMaskIntoConstraints = true
            whiteOverBlurView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            addSubview(whiteOverBlurView)
            whiteOverBlurView.frame = bounds
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    // MARK: Layout constants
    
    struct ControlLayout {
        static let verticalOffset: CGFloat = 18
        static let height: CGFloat = 44
        static let width: CGFloat = 44
        static let edgeOffset: CGFloat = 20
    }
    
    // MARK: Buttons
    
    func showControls(_ show: Bool, animated: Bool = true) {
        let newAlpha: CGFloat = show ? 1 : 0
        let controls = view.subviews.filter {
            return $0 is WorldControl
        }
        
        let duration = animated ? WorldConfiguration.controlsFadeDuration : 0
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
            for view in controls {
                view.alpha = newAlpha
            }
        }, completion: nil)
    }
    
    func addControlButtons() {
        // Audio button
        let audioContainer = OverlayView()
        
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 14.0, *) {
            audioContainer.transform = CGAffineTransform(scaleX: 0.77, y: 0.77)
        }
        #endif
        
        view.addSubview(audioContainer)
        
        audioContainer.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            audioContainer.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: ControlLayout.verticalOffset),
            audioContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -ControlLayout.edgeOffset),
            audioContainer.heightAnchor.constraint(equalToConstant: ControlLayout.height),
            audioContainer.widthAnchor.constraint(equalToConstant: ControlLayout.width)
        ])
        
        updateAudioButtonImage()
        audioButton.imageView?.contentMode = .scaleAspectFit
        audioButton.translatesAutoresizingMaskIntoConstraints = true
        audioButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        audioButton.addTarget(self, action: #selector(toggleBackgroundAudio(_:)), for: .touchUpInside)
        audioContainer.addSubview(audioButton)
    }
    
    // MARK: Actions
    
    /// Sets the world and actor `commandSpeed` based on the page’s current `executionMode`.
    func setCommandSpeedForSpeedIndex() {
        let speedIndex: Int
        
        let mode = PlaygroundPage.current.executionMode
        switch mode {
        case .run, .step, .stepSlowly: speedIndex = 0
        case .runFaster: speedIndex = 1
        case .runFastest: speedIndex = 2
        }
    
        setCommandSpeed(forIndex: speedIndex)
    }
    
    private func setCommandSpeed(forIndex index: Int) {
        guard WorldConfiguration.Actor.possibleSpeeds.indices.contains(index) else {
            fatalError("Invalid speed index: \(index).")
        }
            
        GridWorld.commandSpeed = WorldConfiguration.Scene.possibleSpeeds[index]
        Actor.commandSpeed = WorldConfiguration.Actor.possibleSpeeds[index]
    }
    
    @objc func toggleBackgroundAudio(_ button: UIButton) {
        // Dismiss a previous presented `AudioMenuController`.
        if let vc = presentedViewController as? AudioMenuController {
            vc.dismiss(animated: true, completion: nil)
            return
        }
        
        //if VO is running, turn off both sound and audio and don't trigger popover
        if UIAccessibility.isVoiceOverRunning {
            enableCharacterAudio(!audioController.isPlaying)
            enableBackgroundAudio(!audioController.isPlaying)
            return
        }
        
        let menu = AudioMenuController()
        menu.modalPresentationStyle = .popover
        menu.popoverPresentationController?.passthroughViews = [view]
        
        menu.popoverPresentationController?.permittedArrowDirections = .up
        menu.popoverPresentationController?.sourceView = button
        
        // Offset the popup arrow under the button.
        menu.popoverPresentationController?.sourceRect = CGRect(x: 0, y: 5, width: 44, height: 44)
        
        menu.popoverPresentationController?.delegate = self
        menu.backgroundAudioEnabled = audioController.isPlaying
        menu.delegate = self
        
        present(menu, animated: true, completion: nil)
    }
    
    // MARK: Goal Counter
    
    func addGoalCounter() {
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 14.0, *) {
            goalCounter.transform = CGAffineTransform(scaleX: 0.77, y: 0.77)
        }
        #endif
        
        view.addSubview(goalCounter)
        goalCounter.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            goalCounter.topAnchor.constraint(equalTo: liveViewSafeAreaGuide.topAnchor, constant: ControlLayout.verticalOffset),
            goalCounter.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: ControlLayout.edgeOffset),
            goalCounter.heightAnchor.constraint(equalToConstant: ControlLayout.height),
        ])
    }
    
    func updateCounterLabelTotals() {
        let world = scene.gridWorld
        
        // Create a nested function to evaluate custom criteria with.
        func evaluateCriteria(_ criteria: GridWorld.SuccessCriteria) {
            switch criteria {
            case .allGoals:
                let existingGoals = world.existingGoals()
                let collectedGems = scene.commandQueue.collectedGemCount()
                
                goalCounter.totalGemCount = existingGoals.gems.count + collectedGems
                goalCounter.totalSwitchCount = existingGoals.switches.count
            
            case let .count(collectedGems: gems, openSwitches: switches):
                goalCounter.totalGemCount = gems
                goalCounter.totalSwitchCount = switches
                
            case .ignoreGoals:
                goalCounter.totalGemCount = 0
                goalCounter.totalSwitchCount = 0
            
            case let .custom(criteria, _):
                evaluateCriteria(criteria)
            }
        }
        
        evaluateCriteria(world.successCriteria)
    }
    
    func updateCounterLabelRunningCounts() {
        goalCounter.gemCount = scene.commandQueue.collectedGemCount()
        
        let switches = scene.gridWorld.existingItems(ofType: Switch.self)
        goalCounter.switchCount = switches.reduce(0) { onCount, item in
            return onCount + (item.isOn ? 1 : 0)
        }
    }
}

extension SceneController {
    // MARK: Touch Gestures 
    
    func registerForTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func tapAction(_ recognizer: UITapGestureRecognizer) {
        dismissAudioMenu()
        
        let p = recognizer.location(in: scnView)
        let hitResults = scnView.hitTest(p, options: [:])
        guard let closestHit = hitResults.first else { return }
        
        if scene.gridWorld.shouldShowPicker(from: closestHit.node), let actor = scene.mainActor {
            presentCharacterPicker(from: actor)
        }
        else {
            // Display coordinate marker.
            overlay?.displayMarkerFor(hit: closestHit)
        }
    }
    
    func presentCharacterPicker(from actor: Actor) {
        guard self.characterPicker == nil else { return }
        
        let characterPicker = CharacterPickerController(view: view, for: scene.scnScene)
        self.characterPicker = characterPicker
        
        // Hit actor node, display the characterPicker.
        characterPicker.delegate = self
        
        audioController.endCurrentSong()
        
        // Remove the view’s accessibility elements to make room for the character picker.
        gridWorldAXContainerView.isHidden = true
        view.accessibilityElements = nil
        accessibilityCustomActions = nil
        
        characterPicker.show(from: actor)
        
        showControls(false)
        cameraController?.shouldSuppressGestureControl = true
    }
}

extension SceneController: UIPopoverPresentationControllerDelegate, CharacterPickerDelegate {
    // MARK: CharacterPickerDelegate
    
    func characterPickerWillShow(_ picker: CharacterPickerController) {
        audioController.transitionToCharacterPicker()
        
        #if targetEnvironment(macCatalyst)
        
        // Move AX focus to the first character in the picker.
        // The announcement is prefaced to the AX focus element due to rdar://59350425.
        UIAccessibility.post(notification: .screenChanged, argument: picker.view)
        
        #else
        
        // Move AX focus to the first character in the picker after the announcement has finished.
        // This allows the announcement to be heard in full before the AX focus lands on the first character.
        voiceOverAnnouncementDidFinishCompletion = {
            UIAccessibility.post(notification: .screenChanged, argument: picker.view)
        }
        UIAccessibility.post(notification: .announcement, argument: NSLocalizedString("Entering character picker.", comment: "AX entering character picker."))
        
        #endif
    }
    
    func characterPicker(_ picker: CharacterPickerController, willDismissPicking: ActorType) {
        audioController.endCurrentSong(maximumDelay: 2)
    }
    
    func characterPicker(_ picker: CharacterPickerController, didDismissPicking type: ActorType) {
        showControls(true)
        cameraController?.shouldSuppressGestureControl = false
        
        // Release the old picker (character geo, scene, etc.).
        characterPicker = nil
        
        // Transition back to the puzzle with the new character type. 
        audioController.startPuzzleSong(for: type)
        
        setVoiceOverForCurrentStatus()
    }
    
    // MARK: UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    /// Dismisses the audio menu if visible.
    func dismissAudioMenu() {
        if let vc = presentedViewController as? AudioMenuController {
            vc.dismiss(animated: true, completion: nil)
        }
    }
}

extension SceneController: AudioMenuDelegate, AudioPlaybackDelegate {
    // MARK: Audio
    
    /// Changes the audio button image when audio is disabled.
    func updateAudioButtonImage(on: Bool = Persisted.isAllAudioEnabled) {
        let image: UIImage?
        if on {
            image = UIImage(named: "Sound")?.withRenderingMode(.alwaysTemplate)
        }
        else {
            image = UIImage(named: "SoundOff")?.withRenderingMode(.alwaysTemplate)
        }
        
        audioButton.setImage(image, for: .normal)
    }
    
    // MARK: AudioPlaybackDelegate
    
    func audioSession(_ session: AudioSession, isPlaybackBlocked: Bool) {
        // Set the backgroundAudio to play if not blocked and the user settings enable background audio.
        let shouldPlay = !isPlaybackBlocked && Persisted.isBackgroundAudioEnabled
        audioController.isPlaying = shouldPlay
        
        // Set the scene audio options depending on the state of playback. 
        let options = isPlaybackBlocked ? [] : Scene.persistedAmbientAudioOptions()
        scene.configureAmbientAudio(options: options)
        
        // Check the user preferences, and the current session.
        let allAudioIsPlayable = Persisted.areSoundEffectsEnabled && shouldPlay
        updateAudioButtonImage(on: allAudioIsPlayable)
        
        // Dismiss the menu if this callback overrides the persisted options.
        if allAudioIsPlayable != Persisted.isAllAudioEnabled {
            dismissAudioMenu()
        }
    }
    
    // MARK: AudioMenuDelegate
    
    func enableCharacterAudio(_ isEnabled: Bool) {
        for actor in scene.actors {
            if isEnabled {
                actor.addComponent(AudioComponent(actor: actor))
            }
            else {
                actor.removeComponent(ofType: AudioComponent.self)
            }
        }
        
        // Persist the choice.
        Persisted.areSoundEffectsEnabled = isEnabled
        updateAudioButtonImage()
        
        scene.configureAmbientAudio()
    }
    
    func enableBackgroundAudio(_ isEnabled: Bool) {
        audioController.isPlaying = isEnabled
        
        // Persist the choice.
        Persisted.isBackgroundAudioEnabled = isEnabled
        updateAudioButtonImage()
        
        // Set current session to allow for other music to be played.
        AudioSession.current.configureEnvironment(forSoloPlayback: isEnabled)
        
        scene.configureAmbientAudio()
    }
}
