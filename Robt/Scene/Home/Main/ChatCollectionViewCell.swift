//
//  ChatCollectionViewCell.swift
//  Robt
//
//  Created by hong on 2023/03/29.
//

import Then
import UIKit

final class ChatCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: ChatCollectionViewCell.self)

    private lazy var messageLabel = UILabel().then {
        $0.font = Font.medium(size: 16)
        $0.numberOfLines = 0
        $0.textColor = .black
    }

    private lazy var messageView = UIStackView().then {
        $0.backgroundColor = .yellow
        $0.layer.cornerRadius = 10
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private lazy var bubbleView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillProportionally
        $0.spacing = 10
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
        messageView.addArrangedSubview(messageLabel)
        bubbleView.addArrangedSubview(messageView)
        layoutConfigure()
    }

    private func layoutConfigure() {
        bubbleView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
        }
        messageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.lessThanOrEqualToSuperview()
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }

    func bind(chat: ChatMessage) {
        messageLabel.text = chat.content
        switch chat.role {
        case .user:
            messageLabel.textAlignment = .right
            bubbleView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(20)
                make.leading.lessThanOrEqualToSuperview().inset(50)
            }
        case .system, .assistant:
            messageLabel.textAlignment = .left
            bubbleView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(20)
                make.trailing.lessThanOrEqualToSuperview().inset(50)
            }
        }
    }
}
