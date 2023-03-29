//
//  ChatWithRobotViewController.swift
//  Robt
//
//  Created by hong on 2023/03/28.
//

import SnapKit
import Then
import UIKit

final class ChatWithRobotViewController: UIViewController {

    private enum Section {
        case main
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatMessage>!
    private var commentTextField = CommentTextField(left: 20, right: 20).then {
        $0.backgroundColor = UIColor.gray
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor.purple.cgColor
        $0.layer.borderWidth = 2
        $0.placeholder = "Enter message"
    }

    private var commentView = UIView()

    private var chatMessages: [ChatMessage] = [
        .init(text: "awehotawhotwaoawtehpawwopiapowhpio"),
        .init(text: "WAetaweahwotatwhtw\nawethoewathatwehoaitwehpoawiowethpoithoatw")
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureDataSource()
        applySnapshot()
        commentViewConfigure()
    }
}

extension ChatWithRobotViewController {

    private func configureCollectionView() {
        let layout = createLayout()
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.backgroundColor = .white
        collectionView.register(ChatCollectionViewCell.self, forCellWithReuseIdentifier: "ChatMessageCell")
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    private func configureDataSource() {
        dataSource = UICollectionViewDiffableDataSource<Section, ChatMessage>(collectionView: collectionView) { collectionView, indexPath, item in

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ChatMessageCell", for: indexPath) as! ChatCollectionViewCell
            cell.configure(with: item, who: true)
            return cell
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 16, bottom: 10, trailing: 16)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(100))
        let group = NSCollectionLayoutGroup.vertical(layoutSize: groupSize, subitem: item, count: 1)
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10
        section.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func applySnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        snapshot.appendSections([.main])
        let messageItems = chatMessages
        snapshot.appendItems(messageItems, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }

    func addChatMessage(_ chatMessage: ChatMessage) {
        chatMessages.append(chatMessage)
        applySnapshot()
        collectionView.scrollToItem(at: IndexPath(item: chatMessages.count - 1, section: 0), at: .bottom, animated: true)
    }
}

extension ChatWithRobotViewController {
    private func commentViewConfigure() {
        view.addSubview(commentView)
        commentView.addSubview(commentTextField)

        commentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(100)
        }
        commentTextField.snp.makeConstraints { make in
            make.edges.equalTo(commentView).inset(30)
        }
    }
}
