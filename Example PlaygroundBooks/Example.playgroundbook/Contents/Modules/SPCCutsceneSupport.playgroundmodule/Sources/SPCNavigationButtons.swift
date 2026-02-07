//
//  SPCNavigationButtons.swift
//
//  Copyright © 2020 Apple Inc. All rights reserved.
//

import UIKit

@objc(SPCNavigationButtons)
class SPCNavigationButtons : UIView {

    var currentPage: UInt = 1 {
        didSet {
            updateVisibleElements()
        }
    }

    var pageCount: UInt = 1 {
        didSet {
            updateVisibleElements()
        }
    }

    var showsContinueButtonOnLastPage: Bool = true

    var prevPageButton: UIButton {
        get {
            return prevButton
        }
    }

    var nextPageButton: UIButton {
        get {
            return nextButton
        }
    }

    var nextDocButton: UIButton {
        get {
            return continueButton
        }
    }

    // MARK:-

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        initialSetup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialSetup()
    }

    private func initialSetup() {

        let bubbleHeight: CGFloat = 44.0

        fill(self, with: stackView)
        fill(stackView, with: shadowView)
        fill(shadowView, with: effectsView)

        NSLayoutConstraint.activate([
            prevButton.widthAnchor.constraint(equalToConstant: bubbleHeight),
            prevButton.heightAnchor.constraint(equalToConstant: bubbleHeight),
            nextButton.widthAnchor.constraint(equalToConstant: bubbleHeight),
            nextButton.heightAnchor.constraint(equalToConstant: bubbleHeight)
        ])

        stackView.addArrangedSubview(prevButton)
        stackView.addArrangedSubview(pageLabel)
        stackView.addArrangedSubview(continueButton)
        stackView.addArrangedSubview(nextButton)

        updateVisibleElements()
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        effectsView.layer.cornerRadius = self.bounds.height / 2.0
    }

    // MARK:-

    private func fill(_ parent: UIView, with child: UIView) {

        parent.addSubview(child)
        NSLayoutConstraint.activate([
            child.leadingAnchor.constraint(equalTo: parent.leadingAnchor),
            child.trailingAnchor.constraint(equalTo: parent.trailingAnchor),
            child.topAnchor.constraint(equalTo: parent.topAnchor),
            child.bottomAnchor.constraint(equalTo: parent.bottomAnchor)
        ])
    }

    private func updateVisibleElements() {

        let onFirstPage = currentPage == 1
        let onLastPage = currentPage == pageCount

        prevButton.isEnabled = !onFirstPage
        nextButton.isEnabled = !onLastPage

        prevButton.tintColor = prevButton.isEnabled ? UIColor.systemBlue : UIColor.systemGray
        nextButton.tintColor = nextButton.isEnabled ? UIColor.systemBlue : UIColor.systemGray

        let showContinueButton = showsContinueButtonOnLastPage && onLastPage

        pageLabel.isHidden = showContinueButton
        continueButton.isHidden = !showContinueButton

        // Animate the changes to the layout of the stack view.
        UIView.animate(withDuration: 0.2) {
            self.layoutIfNeeded()
        }

        if !pageLabel.isHidden {
            let template = NSLocalizedString("%u of %u", comment: "label text: indicates which page the user is seeing, CURRENT of TOTAL")
            let text = String(format: template, currentPage, pageCount)
            pageLabel.text = text
        }
    }

    // MARK:-

    private lazy var stackView: UIStackView = {

        let stack = UIStackView(frame: .zero)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 18.0

        return stack
    }()

    private lazy var shadowView: UIView = {

        let shadow = UIView(frame: .zero)
        shadow.translatesAutoresizingMaskIntoConstraints = false

        shadow.layer.shadowColor = UIColor.black.cgColor
        shadow.layer.shadowOpacity = 0.15
        shadow.layer.shadowOffset = CGSize(width: 0, height: 2)
        shadow.layer.shadowRadius = 1

        return shadow
    }()

    private lazy var effectsView: UIVisualEffectView = {

        let effects = UIVisualEffectView(frame: .zero)
        effects.translatesAutoresizingMaskIntoConstraints = false

        effects.layer.masksToBounds = true

        if #available(iOS 13.0, *) {
            effects.effect = UIBlurEffect(style: .systemThickMaterial)
        }

        return effects
    }()

    private lazy var pageLabel: UILabel = {

        let label = UILabel(frame: .zero)
        label.translatesAutoresizingMaskIntoConstraints = false

        label.textAlignment = .center
        label.font = .monospacedDigitSystemFont(ofSize: 22, weight: .regular)

        return label
    }()

    private lazy var prevButton: UIButton = {

        let prev = UIButton()
        prev.translatesAutoresizingMaskIntoConstraints = false

        prev.setImage(chevronLeft.withRenderingMode(.alwaysTemplate), for: .normal)
        prev.accessibilityLabel = NSLocalizedString("previous", comment: "accessibility label for the button that takes the user to the previous scene")

        return prev
    }()

    private lazy var nextButton: UIButton = {

        let next = UIButton()
        next.translatesAutoresizingMaskIntoConstraints = false

        next.setImage(chevronRight.withRenderingMode(.alwaysTemplate), for: .normal)
        next.accessibilityLabel = NSLocalizedString("next", comment: "accessibility label for the button that takes the user to the next scene")

        return next
    }()

    private lazy var continueButton: UIButton = {

        let go = UIButton()
        go.translatesAutoresizingMaskIntoConstraints = false
        go.titleLabel?.font = .systemFont(ofSize: 22)
        go.setTitleColor(UILabel().textColor, for: .normal)

        go.setTitle(NSLocalizedString("Start Coding", comment: "button title: when tapped user will proceed to another screen to start coding"), for: .normal)

        return go
    }()

    private lazy var chevronRight: UIImage = {

        return UIImage(named: "chevron")!.scaledToFit(within: CGSize(width: 24, height: 24))
    }()

    private lazy var chevronLeft: UIImage = {

        return UIImage(cgImage: chevronRight.cgImage!, scale: chevronRight.scale, orientation: .upMirrored)
    }()
}
