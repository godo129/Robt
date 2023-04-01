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
        $0.textAlignment = .center
        $0.font = Font.medium(size: 16)
        $0.numberOfLines = 0
    }

    private lazy var bubbleView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 10
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.isLayoutMarginsRelativeArrangement = true
        $0.backgroundColor = .purple
        $0.layer.cornerRadius = 10
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
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
        bubbleView.setCustomSpacing(8, after: messageLabel)
    }

    private func layoutConfigure() {
        bubbleView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        bubbleView.snp.removeConstraints()
        messageLabel.snp.removeConstraints()
    }

    func bind(chat: ChatMessage) {
        messageLabel.text = chat.content
        switch chat.role {
        case .assistant, .system:
            messageLabel.textAlignment = .right
            bubbleView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(50)
                make.leading.lessThanOrEqualToSuperview().inset(50)
            }
        case .user:
            messageLabel.textAlignment = .left
            bubbleView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(50)
                make.trailing.lessThanOrEqualToSuperview().inset(50)
            }
        }
    }
}
