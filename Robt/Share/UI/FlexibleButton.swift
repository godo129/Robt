//
//  FlexibleButton.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import UIKit

final class FlexibleButton: UIButton {

    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(
            CGSize(
                width: frame.size.width,
                height: CGFloat.greatestFiniteMagnitude
            )
        ) ?? .zero
        let buttonSize = CGSize(
            width: labelSize.width + contentEdgeInsets.left + contentEdgeInsets.right,
            height: labelSize.height + contentEdgeInsets.top + contentEdgeInsets.bottom
        )
        return buttonSize
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.size.height / 2
    }
}
