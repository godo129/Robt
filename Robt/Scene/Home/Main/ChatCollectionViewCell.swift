//
//  ChatCollectionViewCell.swift
//  Robt
//
//  Created by hong on 2023/03/29.
//

import Combine
import Then
import UIKit

final class ChatCollectionViewCell: UICollectionViewCell {

    static let identifier = String(describing: ChatCollectionViewCell.self)
    private var index: Int?

    private lazy var reportButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "exclamationmark.bubble.fill")!, for: .normal)
        $0.setImage(UIImage(systemName: "exclamationmark.bubble.fill")!, for: .highlighted)
    }

    private lazy var messageLabel = UILabel().then {
        $0.font = Font.medium(size: 16)
        $0.numberOfLines = 0
        $0.textColor = .black
    }

    private lazy var messageView = UIStackView().then {
        $0.layer.cornerRadius = 10
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private lazy var bubbleView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.isLayoutMarginsRelativeArrangement = true
    }

//    private lazy var longPressRecognizer: UILongPressGestureRecognizer = {
//        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//        recognizer.minimumPressDuration = 2.0
//        return recognizer
//    }()

    private let reportButtonPressed = PassthroughSubject<Int?, Never>()
//    @objc private func handleLongPress(_ recognizer: UILongPressGestureRecognizer) {
//        if recognizer.state == .began {
//            // handle the long press by publishing the event using the subject
//            longPressSubject.send(message)
//        }
//    }

    // expose the long press subject as a publisher
    var reportButtonPressedPublish: AnyPublisher<Int?, Never> {
        reportButtonPressed.eraseToAnyPublisher()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
//        addGestureRecognizer(longPressRecognizer)
        reportButton.addTarget(self, action: #selector(deleteActionViewPopUp), for: .touchUpInside)
    }

    @objc func deleteActionViewPopUp() {
        let alert = UIAlertController(
            title: "해당 메시지를 차단하시겠습니까?",
            message: "해당 메시지가 삭제됩니다",
            preferredStyle: .alert
        )

        let cancelAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        alert.addAction(cancelAction)

        let deleteAction = UIAlertAction(title: "예", style: .destructive) { [weak self] _ in
            guard let self else { return }
            self.reportButtonPressed.send(self.index)
        }
        alert.addAction(deleteAction)

        window?.rootViewController?.present(alert, animated: true)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ChatCollectionViewCell {
    private func configure() {
        addSubview(bubbleView)
        bubbleView.addArrangedSubview(messageView)
        layoutConfigure()
    }

    private func layoutConfigure() {
        bubbleView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
                .inset(20)
        }
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        messageLabel.text = nil
        index = nil
        messageView.removeArrangedSubview(reportButton)
        messageView.removeArrangedSubview(messageLabel)
    }

    func bind(chat: ChatMessage, index: Int) {
        self.index = index
        messageLabel.text = chat.content
        switch chat.role {
        case .user:
            messageLabel.textAlignment = .right
            bubbleView.alignment = .trailing
            messageView.backgroundColor = .yellow
            messageView.addArrangedSubview(reportButton)
            messageView.addArrangedSubview(messageLabel)

        case .system, .assistant:
            messageLabel.textAlignment = .left
            bubbleView.alignment = .leading
            messageView.backgroundColor = .green
            messageView.addArrangedSubview(messageLabel)
            messageView.addArrangedSubview(reportButton)
        }
    }
}
