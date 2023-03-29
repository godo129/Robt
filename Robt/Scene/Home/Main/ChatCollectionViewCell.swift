//
//  ChatCollectionViewCell.swift
//  Robt
//
//  Created by hong on 2023/03/29.
//

import Then
import UIKit

final class ChatCollectionViewCell: UICollectionViewCell {

    private lazy var messageLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = Font.medium(size: 16)
        $0.textColor = .black
    }

    private lazy var bubbleView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 10
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = .yellow
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        backgroundColor = .yellow
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatCollectionViewCell {
    private func configure() {
        addSubview(bubbleView)
        bubbleView.addArrangedSubview(messageLabel)
        layoutConfigure()
    }

    private func layoutConfigure() {
        bubbleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        messageLabel.snp.makeConstraints { make in
            make.edges.equalTo(bubbleView)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }

    func bind(text: String) {
        messageLabel.text = text
    }
}
