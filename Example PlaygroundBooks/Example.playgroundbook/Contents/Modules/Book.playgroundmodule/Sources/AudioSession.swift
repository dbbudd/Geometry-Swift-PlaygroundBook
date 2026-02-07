//
//  AudioSession.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import UIKit
import AVFoundation

protocol AudioPlaybackDelegate: class {
    func audioSession(_ session: AudioSession, isPlaybackBlocked: Bool)
}

/// The shared `AVAudioSession`.
private let session = AVAudioSession.sharedInstance()

class AudioSession {
    
    static let current = AudioSession()
    
    weak var delegate: AudioPlaybackDelegate?
    
    /// Returns `true` if audio playback is blocked.
    private(set) var isPlaybackBlocked = false
    
    /// Marks if the extension is currently in the background.
    private(set) var isInBackground = false
    
    private var notificationObservers = [Any]()

    /*
     When VoiceOver is disabled, UIAccessibilityIsVoiceOverRunning() will immediately start
     returning false. VoiceOver will also start to announce "VoiceOver off". Because of this
     announcement, the AVAudioSessionSilenceSecondaryAudioHint notification will fire when
     the announcement starts and when it completes.

     If the logic in our handler for AVAudioSessionSilenceSecondaryAudioHint were to just use
     UIAccessibilityIsVoiceOverRunning(), it would assume the user’s music had begun playing
     when "VoiceOver off" is announced. We therefore have to track this state ourselves using
     voiceOverWasRunningAtLastStatusChange and voiceOverIsAnnouncingVoiceOverOff.
     */
    private var voiceOverWasRunningAtLastStatusChange = UIAccessibility.isVoiceOverRunning
    private var voiceOverIsAnnouncingVoiceOverOff = false
    
    private init() {
        let nc = NotificationCenter.default

        // Register for VoiceOver status changes.
        let voiceOverStatusDidChangeNotificationName: Notification.Name
        voiceOverStatusDidChangeNotificationName = UIAccessibility.voiceOverStatusDidChangeNotification

        let voiceOverStatusChanged = nc.addObserver(forName: voiceOverStatusDidChangeNotificationName, object: nil, queue: .main) { [weak self] notification in
            // Get the current and previous state of VoiceOver.
            guard let voiceOverWasRunningAtLastStatusChange = self?.voiceOverWasRunningAtLastStatusChange else { return }
            let voiceOverIsRunning = UIAccessibility.isVoiceOverRunning

            if !voiceOverIsRunning && voiceOverWasRunningAtLastStatusChange {
                // VoiceOver has turned off and has begun announcing "VoiceOver is off".
                self?.voiceOverIsAnnouncingVoiceOverOff = true
            }
            else if voiceOverIsRunning {
                // VoiceOver is on so it can’t be announcing "VoiceOver is off".
                self?.voiceOverIsAnnouncingVoiceOverOff = false
            }

            // Record the current state of VoiceOver.
            self?.voiceOverWasRunningAtLastStatusChange = voiceOverIsRunning
        }
        
        // Register for session notifications.
        let interrupted = nc.addObserver(forName: AVAudioSession.interruptionNotification, object: nil, queue: .main) { [weak self] notification in
            guard let info = notification.userInfo,
                let isInterrupted = info[AVAudioSessionInterruptionTypeKey] as? Bool else {
                return
            }
            
            let isPlayingOtherAudio = session.secondaryAudioShouldBeSilencedHint
            
            self?.audioSessionIsBlocked(isInterrupted || isPlayingOtherAudio)
            
            if isPlayingOtherAudio {
                self?.configureEnvironment(forSoloPlayback: false)
            }
        }
        
        let secondaryAudio = nc.addObserver(forName: AVAudioSession.silenceSecondaryAudioHintNotification, object: nil, queue: .main) { [weak self] notification in
            guard let isAnnouncingVoiceOverOff = self?.voiceOverIsAnnouncingVoiceOverOff,
                let info = notification.userInfo,
                let isPlayingSecondaryAudio = info[AVAudioSessionSilenceSecondaryAudioHintTypeKey] as? Bool else {
                    return
            }

            if !isPlayingSecondaryAudio && isAnnouncingVoiceOverOff {
                // VoiceOver has finished announcing "VoiceOver is off".
                self?.voiceOverIsAnnouncingVoiceOverOff = false
            }
            else if isPlayingSecondaryAudio && !UIAccessibility.isVoiceOverRunning && !isAnnouncingVoiceOverOff {
                // Update the current session if we are playing audio that is not associated with VoiceOver.
                self?.audioSessionIsBlocked(true)
                self?.configureEnvironment(forSoloPlayback: false)
            }
        }
        
        let routeChanged = nc.addObserver(forName: AVAudioSession.routeChangeNotification, object: nil, queue: .main) { [weak self] _ in
            // dispatch asynchronously avoiding a deadlock with SceneKit for macCatalyst
            DispatchQueue.main.async {
                // When the route changes mark the session as unblocked
                // (this will fallback to match the users preferences).
                self?.audioSessionIsBlocked(false)
            }
        }
        
        // Register for extension notifications.
        let inactive = nc.addObserver(forName: .NSExtensionHostDidEnterBackground, object: nil, queue: .main) { [weak self] _ in
            self?.isInBackground = true
            
            self?.audioSessionIsBlocked(true)
        }
        
        let active = nc.addObserver(forName: .NSExtensionHostWillEnterForeground, object: nil, queue: .main) { [weak self] _ in
            self?.isInBackground = false
            
            if !session.secondaryAudioShouldBeSilencedHint {
                self?.audioSessionIsBlocked(false)
            }
        }
        
        notificationObservers = [voiceOverStatusChanged, interrupted, secondaryAudio, routeChanged, active, inactive]
    }
    
    deinit {
        for observer in notificationObservers {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    private func audioSessionIsBlocked(_ blocked: Bool) {
        isPlaybackBlocked = blocked
        
        delegate?.audioSession(self, isPlaybackBlocked: blocked || isInBackground)
    }
    
    func configureEnvironment(forSoloPlayback: Bool = false) {
        // Configure the audio environment.
        let category: AVAudioSession.Category = forSoloPlayback ? .soloAmbient : .ambient
        do {
            try session.setCategory(category, mode: .default, options: [.mixWithOthers])
            
            DispatchQueue(label: "com.LTC.AudioSession").async {
                let _ = try? session.setActive(true)
            }
        } catch {
            log(message: "Failed to configure audio environment \(error).")
        }
    }
}
