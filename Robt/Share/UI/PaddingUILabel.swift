//
//  PaddingUILabel.swift
//  Robt
//
//  Created by hong on 2023/05/02.
//

import UIKit

final class PaddingUILabel: UILabel {
    private let textPadding: UIEdgeInsets

    init(
        top: CGFloat = 0,
        bottom: CGFloat = 0,
        left: CGFloat = 0,
        right: CGFloat = 0
    ) {
        self.textPadding = UIEdgeInsets(top: top, left: left, bottom: bottom, right: right)
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textPadding))
    }

    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += textPadding.top + textPadding.bottom
        contentSize.width += textPadding.left + textPadding.right
        return contentSize
    }
}
