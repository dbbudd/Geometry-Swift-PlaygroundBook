//
//  AudioMenuController.swift
//  
//  Copyright © 2016-2019 Apple Inc. All rights reserved.
//

import UIKit

protocol AudioMenuDelegate: class {
    func enableBackgroundAudio(_ isEnabled: Bool)
    func enableCharacterAudio(_ isEnabled: Bool)
}

class AudioMenuController: UITableViewController {
    
    static let cellIdentifier = "SwitchTableViewCell"
    static let contentSizeKeyPath = "contentSize"
    
    enum CellIndex: Int {
        case backgroundAudio
        case characterAudio
    }
    
    static let minimumWidth: CGFloat = 200.0
    
    // MARK: Properties
    
    weak var delegate: AudioMenuDelegate?
    
    var backgroundAudioEnabled = Persisted.isBackgroundAudioEnabled
    
    var characterAudioEnabled = Persisted.areSoundEffectsEnabled
    
    // MARK: View Controller Life-Cycle 
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        // Fixes table view alignment in popover.
        // rdar://problem/53461836
        tableView.alwaysBounceVertical = false
        tableView.alwaysBounceHorizontal = false
        
        tableView.allowsSelection = false
        tableView.separatorInset = .zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Self.cellIdentifier)
        
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 14.0, *) {
            tableView.rowHeight = CGFloat(34)
        }
        #else
            tableView.rowHeight = UITableView.automaticDimension
        #endif
        
        // Observe changes to the table view’s content size.
        tableView.addObserver(self, forKeyPath: Self.contentSizeKeyPath, options: .new, context: nil)
        
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 14.0, *) {
            preferredContentSize = getPreferredContentSize()
        }
        #endif
    }
    
    deinit {
        tableView.removeObserver(self, forKeyPath: Self.contentSizeKeyPath)
    }
    
    override public func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        guard keyPath == Self.contentSizeKeyPath else { return }
        // Recompute preferredContentSize each time the table view’s content size changes.
        preferredContentSize = getPreferredContentSize()
    }
    
    private func getPreferredContentSize() -> CGSize {
        let rowCount = tableView.numberOfRows(inSection: 0)
        guard rowCount > 0 else { return super.preferredContentSize }
        let padding = tableView.rectForRow(at: IndexPath(row: 0, section: 0)).size.height // One row height
        var preferredSize = CGSize(width: Self.minimumWidth, height: 0.0)
        // Width is determined by the widest cell. Computed manually for a more compact width.
        for row in 0..<rowCount {
            let cell = tableView(tableView, cellForRowAt: IndexPath(row: row, section: 0))
            guard let label = cell.textLabel, let accessoryView = cell.accessoryView else { continue }
            label.sizeToFit()
            let cellWidth = label.frame.width + accessoryView.frame.width + padding
            preferredSize.width = max(cellWidth, preferredSize.width)
        }
        // Height is available from the table view’s content size.
        preferredSize.height = tableView.contentSize.height
        return preferredSize
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let index = CellIndex(rawValue: indexPath.row) else {
            fatalError("Invalid index \(indexPath.row) in \(self)")
        }
        
        var systemFontSize = CGFloat(17)
        
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 14.0, *) {
            systemFontSize = CGFloat(14)
        }
        #endif
        
        let cell = tableView.dequeueReusableCell(withIdentifier: AudioMenuController.cellIdentifier, for: indexPath)
        cell.textLabel?.font = UIFont.systemFont(ofSize: systemFontSize, weight: UIFont.Weight.regular)
        
        let switchControl = UISwitch()
        cell.accessoryView = switchControl
        
        #if targetEnvironment(macCatalyst)
        if #available(macCatalyst 14.0, iOS 14.0, *) {
            switchControl.preferredStyle = .sliding
        }
        #endif

        switch index {
        case .backgroundAudio:
            cell.textLabel?.text = NSLocalizedString("Background music", comment: "Menu label")
            switchControl.isOn = backgroundAudioEnabled
            
            switchControl.addTarget(self, action: #selector(toggleBackgroundAudio(_:)), for: .valueChanged)
        
        case .characterAudio:
            cell.textLabel?.text = NSLocalizedString("Sound effects", comment: "Menu label")
            switchControl.isOn = characterAudioEnabled

            switchControl.addTarget(self, action: #selector(toggleCharacterAudio(_:)), for: .valueChanged)
        }
        
        return cell
    }
    
    // MARK: Switch Actions
    
    @objc func toggleBackgroundAudio(_ control: UISwitch) {
        delegate?.enableBackgroundAudio(control.isOn)
    }
    
    @objc func toggleCharacterAudio(_ control: UISwitch) {
        delegate?.enableCharacterAudio(control.isOn)
    }
}
