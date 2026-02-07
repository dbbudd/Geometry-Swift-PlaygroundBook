//
//  SPCMultilineLabel.swift
//
//  Copyright © 2020 Apple, Inc. All rights reserved.
//

import UIKit

@objc(SPCMultilineLabel)
public class SPCMultilineLabel : UILabel {

    @IBInspectable var idealWidth: CGFloat = 0

    @IBInspectable var maxWidth: CGFloat = 0
    @IBInspectable var maxHeight: CGFloat = 0

    // MARK:-

    public required init?(coder: NSCoder) {
        super.init(coder: coder)

        initialSetup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        initialSetup()
    }

    private func initialSetup() {

        self.numberOfLines = 0
        self.textAlignment = .center
    }

    public override var intrinsicContentSize: CGSize {
        get {
            var idealSize = super.intrinsicContentSize

            if idealWidth != 0 {
                idealSize.width = idealWidth
                idealSize.height = UIScreen.main.bounds.height
            }
            if maxWidth != 0 {
                idealSize.width = min(idealSize.width, maxWidth)
            }
            if maxHeight != 0 {
                idealSize.height = min(idealSize.height, maxHeight)
            }

            let initialResult = sizeThatFits(idealSize)
            var result = initialResult

            if (maxHeight != 0) && (initialResult.height > maxHeight) {
                result.height = maxHeight

                let area = initialResult.width * initialResult.height
                result.width = (area / maxHeight)

                if maxWidth != 0 {
                    result.width = min(result.width, maxWidth)

                    let verifiedSize = sizeThatFits(result)
                    if verifiedSize.height > maxHeight {
                        result.width = maxWidth
                    }
                }
            }
            return result
        }
    }
}
