//
//  UtteranceQueue.swift
//  PlaygroundsContent
//
//  Created by Chad Zeluff on 10/15/19.
//  Copyright © 2019 Apple, Inc. All rights reserved.
//

import AVFoundation

public protocol SpeechUtteranceQueueDelegate: class {
    func utteranceQueue(_ queue: SpeechUtteranceQueue, didFinish utterance: AVSpeechUtterance)
    func utteranceQueue(_ queue: SpeechUtteranceQueue, didCancel utterance: AVSpeechUtterance)
}

public class SpeechUtteranceQueue: NSObject {
    
    public weak var delegate: SpeechUtteranceQueueDelegate?
    
    private var speechUtterances = [AVSpeechUtterance]()
        
    private var speechSynthesizer = AVSpeechSynthesizer()
    
    private var isPlayingUtterances: Bool = false
    
    private var notificationObservers = [Any]()
    
    public override init() {
        super.init()
        
        let nc = NotificationCenter.default
        
        let closed = nc.addObserver(forName: .liveViewMessageConnectionClosed, object: nil, queue: .main) { [weak self] _ in
            guard let self = self else { return }
            self.speechSynthesizer.stopSpeaking(at: .immediate)
            
            for utterance in self.speechUtterances {
                self.delegate?.utteranceQueue(self, didCancel: utterance)
            }
            
            
            self.speechUtterances.removeAll()
            self.isPlayingUtterances = false
        }
        
        notificationObservers.append(closed)
    }
    
    deinit {
        for observer in notificationObservers {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    public func enqueue(_ utterance: AVSpeechUtterance) {
        speechUtterances.append(utterance)
        playUtterances()
    }
    
    public func stopSpeaking() {
        speechSynthesizer.stopSpeaking(at: .word)
        isPlayingUtterances = false
        speechUtterances.removeAll()
    }
    
    private func playUtterances() {
        guard !isPlayingUtterances && !speechUtterances.isEmpty else { return }
        
        let synthesizer = AVSpeechSynthesizer()
        synthesizer.delegate = self
        speechSynthesizer = synthesizer
        if let utterance = speechUtterances.first, Process.isLiveViewConnectionOpen {
            synthesizer.speak(utterance)
            isPlayingUtterances = true
        } else if let utterance = speechUtterances.first {
            delegate?.utteranceQueue(self, didFinish: utterance)
            isPlayingUtterances = false
            
            playNextUtterance()
        }
    }
    
    private func playNextUtterance() {
        speechUtterances.removeFirst()
        if speechUtterances.count > 0 {
            playUtterances()
        }
    }
}

extension SpeechUtteranceQueue: AVSpeechSynthesizerDelegate {
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        delegate?.utteranceQueue(self, didFinish: utterance)
        isPlayingUtterances = false

        if speechUtterances.count >= 1 {
            playNextUtterance()        }
    }
    
    public func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didCancel utterance: AVSpeechUtterance) {
        delegate?.utteranceQueue(self, didCancel: utterance)
        isPlayingUtterances = false
        
        if speechUtterances.count >= 1 {
            playNextUtterance()
        }
    }
}
