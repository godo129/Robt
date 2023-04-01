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
        messageLabel.snp.makeConstraints { make in
            make.verticalEdges.equalTo(bubbleView.snp.verticalEdges)
            make.horizontalEdges.equalTo(bubbleView.snp.horizontalEdges).inset(20)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
    }

    func bind(text: String, who: Bool) {
        messageLabel.text = text
        if who {
            messageLabel.textAlignment = .right
            bubbleView.snp.makeConstraints { make in
                make.trailing.equalToSuperview().inset(50)
            }
        } else {
            messageLabel.textAlignment = .left
            bubbleView.snp.makeConstraints { make in
                make.leading.equalToSuperview().inset(50)
            }
        }
    }
}
