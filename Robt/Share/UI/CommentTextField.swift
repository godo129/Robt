//
//  CommentTextField.swift
//  Robt
//
//  Created by hong on 2023/03/29.
//

import UIKit

final class CommentTextField: UITextField {

    private let textPadding: CGRect

    init(
        top: CGFloat = 0,
        bottom: CGFloat = 0,
        left: CGFloat = 0,
        right: CGFloat = 0
    ) {
        self.textPadding = CGRect(
            x: left,
            y: top,
            width: left + right,
            height: top + bottom
        )
        super.init(frame: .zero)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return CGRect(
            x: bounds.origin.x + textPadding.origin.x,
            y: bounds.origin.y + textPadding.origin.y,
            width: bounds.width - textPadding.width,
            height: bounds.height - textPadding.height
        )
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}
