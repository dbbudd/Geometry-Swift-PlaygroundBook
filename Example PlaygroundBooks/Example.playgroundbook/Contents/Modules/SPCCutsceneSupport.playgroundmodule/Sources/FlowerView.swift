//
//  FlowerView.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(FlowerView)
public class FlowerView: UIView {

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

        let imageView = UIImageView(image: UIImage(named: "flower"))
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(imageView)

        let topConstraint = imageView.topAnchor.constraint(equalTo: self.topAnchor)
        let bottomConstraint = imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            bottomConstraint
        ])

        self.imageView = imageView
        self.imageViewTopConstraint = topConstraint
        self.imageViewBottomConstraint = bottomConstraint
    }

    // MARK:-

    /// A convenience method used to hide the flower, before introducing it
    /// into a scene using `animateToFullSizeWithBounce(duration:delay:)`.

    public override func shrinkToInvisible() {

        imageViewTopConstraint?.constant = self.bounds.size.height
        imageViewBottomConstraint?.constant = self.bounds.size.height
    }

    /// Animate the size of the flower to its full size, with bounce.
    ///
    /// This is intended to be called to bring the flower into a scene,
    /// after the flower has been hidden using `shrinkToInvisible()`.
    ///
    /// - Parameter duration: The intended duration (seconds) of the animation.
    /// - Parameter delay: The delay (seconds) before this animation is to begin.

    public func animateToFullSizeWithBounce(duration: TimeInterval, delay: TimeInterval, then completion: (() -> Void)? = nil) {

        let bounceHeight: CGFloat = 5.0
        UIView.animate(withDuration: (0.7 * duration), delay: delay, options: [],
                       animations: {
                        self.imageViewTopConstraint?.constant = -bounceHeight
                        self.imageViewBottomConstraint?.constant = -bounceHeight
                        self.layoutIfNeeded()
        },
                       completion: { _ in
                        UIView.animate(withDuration: (0.3 * duration)) {
                            self.imageViewTopConstraint?.constant = 0
                            self.imageViewBottomConstraint?.constant = 0
                            self.layoutIfNeeded()
                        }
                        completion?()
        })
    }

    // MARK:- Private

    private var imageView: UIImageView?
    private var imageViewTopConstraint: NSLayoutConstraint?
    private var imageViewBottomConstraint: NSLayoutConstraint?
}
