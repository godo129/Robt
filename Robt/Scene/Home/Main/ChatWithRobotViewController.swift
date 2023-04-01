//
//  ChatWithRobotViewController.swift
//  Robt
//
//  Created by hong on 2023/03/28.
//

import Combine
import SnapKit
import Then
import UIKit

final class ChatWithRobotViewController: UIViewController {

    private enum Section {
        case main
    }

    private var collectionView: UICollectionView!
    private var dataSource: UICollectionViewDiffableDataSource<Section, ChatMessage>!
    private lazy var commentTextField = CommentTextField(left: 20, right: 20).then {
        $0.backgroundColor = .white
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor.purple.cgColor
        $0.layer.borderWidth = 2
        $0.placeholder = "Enter message"
    }

    private lazy var commentView: UIStackView = .init()
    private lazy var acitivtIndicator: UIActivityIndicatorView = .init(style: .large)

    private let viewModel: ChatWithRobotViewModel
    private var cancellabels: Set<AnyCancellable> = .init()
    private let input: PassthroughSubject<ChatWithRobotViewModel.Input, Never> = .init()

    init(viewModel: ChatWithRobotViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "채팅"
        configureCollectionView()
        configureDataSource()
        commentViewConfigure()
        inidicatorConfigure()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.setTabBarVisible(visible: false, duration: 0.2, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @MainActor
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case let .chatMessages(chats):
                self.applySnapshot(items: chats)
                self.viewInteractiveBlock(false)
            case let .chatError(error):
                print(error)
            }
        }
        .store(in: &cancellabels)

        keyboardHeightPublisher.sink { [weak self] keyboardHeight in
            guard let self else { return }
            self.viewPadding(bottom: keyboardHeight)
        }
        .store(in: &cancellabels)

        commentTextField.inputPublish.sink(receiveValue: { [weak self] text in
            guard let self else { return }
            self.commentTextField.resignFirstResponder()
            self.commentTextField.text = ""
            self.input.send(.message(text))
            self.viewInteractiveBlock(true)
        })
        .store(in: &cancellabels)
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
        dataSource = UICollectionViewDiffableDataSource<Section, ChatMessage>(
            collectionView: collectionView
        ) { collectionView, indexPath, item in

            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "ChatMessageCell",
                for: indexPath
            ) as! ChatCollectionViewCell
            cell.bind(chat: item)
            return cell
        }
    }

    private func createLayout() -> UICollectionViewLayout {
        let heightDimension = NSCollectionLayoutDimension.estimated(500)

        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: heightDimension
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)

        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: heightDimension)
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])

        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 10

        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }

    private func applySnapshot(items: [ChatMessage]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ChatMessage>()
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        snapshot.appendItems(items, toSection: .main)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension ChatWithRobotViewController {
    private func commentViewConfigure() {
        view.addSubview(commentView)
        commentView.addSubview(commentTextField)
        commentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            make.height.equalTo(100)
        }
        commentTextField.snp.makeConstraints { make in
            make.edges.equalTo(commentView).inset(30)
        }
    }

    private func inidicatorConfigure() {
        acitivtIndicator.center = view.center
        view.addSubview(acitivtIndicator)
    }

    private func viewInteractiveBlock(_ bool: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if bool {
                self.view.isUserInteractionEnabled = false
                self.acitivtIndicator.startAnimating()
            } else {
                self.acitivtIndicator.stopAnimating()
                self.view.isUserInteractionEnabled = true
            }
        }
    }
}
