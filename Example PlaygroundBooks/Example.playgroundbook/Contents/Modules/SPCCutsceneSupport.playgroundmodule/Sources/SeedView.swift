//
//  SeedView.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(SeedView)
public class SeedView: UIView {

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

        let seedImage = UIImage(named: "seed")!
        let imageView = UIImageView(image: seedImage)
        imageView.translatesAutoresizingMaskIntoConstraints = false

        self.addSubview(imageView)

        let topConstraint = imageView.topAnchor.constraint(equalTo: self.topAnchor)

        NSLayoutConstraint.activate([
            topConstraint,
            imageView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            imageView.widthAnchor.constraint(equalToConstant: seedImage.size.width),
            imageView.heightAnchor.constraint(equalToConstant: seedImage.size.height)
        ])

        self.imageView = imageView
        self.imageViewTopConstraint = topConstraint
    }

    // MARK:-

    public override func shrinkToInvisible() {

        // Shrink only the image view. Leave the parent view as it is.
        self.imageView?.shrinkToInvisible()
    }

    public override func animateToFullSizeWithPop(duration: TimeInterval, delay: TimeInterval, then completion: (() -> Void)? = nil) {

        // Animate the size of the image view. Leave the parent view as it is.
        self.imageView?.animateToFullSizeWithPop(duration: duration, delay: delay, then: completion)
    }

    /// Animate the seed dropping out of sight.
    ///
    /// - Parameter duration: The intended duration (seconds) of the animation.
    /// - Parameter delay: The delay (seconds) before this animation is to begin.

    public func animateDrop(duration: TimeInterval, delay: TimeInterval, then nextAnimation: (() -> Void)? = nil) {

        UIView.animate(withDuration: duration, delay: delay, options: [.curveEaseIn],
                       animations: {
                        // Send the seed image below the bounds of this view.
                        self.imageViewTopConstraint?.constant = self.bounds.height
                        self.layoutIfNeeded()
        },
                       completion: { _ in
                        nextAnimation?()
        })

    }

    // MARK:- Private

    private var imageView: UIImageView?
    private var imageViewTopConstraint: NSLayoutConstraint?

}
