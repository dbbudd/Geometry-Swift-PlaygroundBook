//
//  CursorView.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(CursorView)
public class CursorView: UIView {

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        initialSetup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialSetup()
    }

    private func initialSetup() {

        self.clipsToBounds = true

        let cursorImage = UIImage(named: "cursor")!
        let imageView = UIImageView(image: cursorImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(imageView)

        let topConstraint = imageView.topAnchor.constraint(equalTo: self.topAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: cursorImage.size.width),
            imageView.heightAnchor.constraint(equalToConstant: cursorImage.size.height)
        ])

        self.imageView = imageView
        self.imageViewTopConstraint = topConstraint
    }

    // MARK:-

    /// Animate the position of the cursor, with a floating / bobbing effect.
    ///
    /// The animation cycle includes a slow down, up, down, up movement.
    ///
    /// - Parameter duration: The intended duration (seconds) of the animation.
    /// - Parameter delay: The delay (seconds) before this animation is to begin.

    public func animateFloat(duration: TimeInterval, delay: TimeInterval) {

        let verticalOffset: CGFloat = 15.0

        self.animateAdjustment(verticalOffset, duration: (0.25 * duration), delay: delay, then: {
            self.animateAdjustment(-verticalOffset, duration: (0.25 * duration), then: {
                self.animateAdjustment(verticalOffset, duration: (0.25 * duration), then: {
                    self.animateAdjustment(-verticalOffset, duration: (0.25 * duration))
                })
            })
        })
    }

    // MARK:- Private

    private var imageView: UIImageView?
    private var imageViewTopConstraint: NSLayoutConstraint?

    private func animateAdjustment(_ adjustment: CGFloat, duration: TimeInterval, delay: TimeInterval = 0.0, then nextAnimation: (() -> Void)? = nil) {

        UIView.animate(withDuration: duration, delay: delay, options: [.curveLinear],
                       animations: {
                        self.imageViewTopConstraint?.constant += adjustment
                        self.layoutIfNeeded()
        },
                       completion: { _ in
                        nextAnimation?()
        })
    }
}
