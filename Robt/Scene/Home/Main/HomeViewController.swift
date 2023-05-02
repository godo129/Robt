//
//  HomeViewController.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import Combine
import SnapKit
import Then
import UIKit

final class HomeViewController: UIViewController {

    private var cancellabels: Set<AnyCancellable> = .init()
    private let input: PassthroughSubject<HomeViewModel.Input, Never> = .init()
    private let viewModel: HomeViewModel

    private lazy var scrollView = UIScrollView()

    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 50
        $0.layoutMargins = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
        $0.isLayoutMarginsRelativeArrangement = true
    }

    private lazy var chatWithRobotContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }

    private lazy var chatWithRobotText = UILabel().then {
        $0.text = "로봇과 채팅하러가기!"
        $0.font = Font.semiBold(size: 20)
        $0.textColor = .black
    }

    private lazy var chatWithRobotButtonTapped = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(named: "robot"), for: .normal)
        $0.setBackgroundColor(.OFFFFFF.withAlphaComponent(0.5), for: .highlighted)
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private lazy var imageGenerateContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }

    private lazy var imageGenerateText = UILabel().then {
        $0.text = "이미지 생성하기!"
        $0.font = Font.semiBold(size: 20)
        $0.textColor = .black
    }

    private lazy var imageGenerateButton = UIButton().then {
        $0.setImage(UIImage(named: "dalle2Images"), for: .normal)
        $0.setBackgroundColor(.OFFFFFF.withAlphaComponent(0.5), for: .highlighted)
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private lazy var audioTranscriptionContainerView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 10
    }

    private lazy var audioTranscriptionText = UILabel().then {
        $0.font = Font.semiBold(size: 20)
        $0.textColor = .black
        $0.text = "오디오 추출"
    }

    private lazy var audioTranscriptionButton = UIButton().then {
        $0.setImage(UIImage(named: "audioToTrnascriptionImage"), for: .normal)
        $0.setBackgroundColor(.OFFFFFF.withAlphaComponent(0.5), for: .highlighted)
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    init(viewModel: HomeViewModel) {
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
        configure()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.setTabBarVisible(visible: true, duration: 0, animated: true)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { _ in
        }
        .store(in: &cancellabels)

        chatWithRobotButtonTapped.tapPublisher.sink { [weak self] _ in
            self?.input.send(.chatWithRobotButtonTapped)
        }
        .store(in: &cancellabels)

        imageGenerateButton.tapPublisher.sink { [weak self] _ in
            self?.input.send(.imageGenerateButtonTapped)
        }
        .store(in: &cancellabels)

        audioTranscriptionButton.tapPublisher.sink { [weak self] in
            self?.input.send(.audioTrnascriptionButtonTapped)
        }
        .store(in: &cancellabels)
    }
}

extension HomeViewController {
    private func configure() {
        view.addSubview(scrollView)
        scrollView.addSubview(stackView)
        [chatWithRobotText, chatWithRobotButtonTapped].forEach {
            chatWithRobotContainerView.addArrangedSubview($0)
        }
        [imageGenerateText, imageGenerateButton].forEach {
            imageGenerateContainerView.addArrangedSubview($0)
        }
        [audioTranscriptionText, audioTranscriptionButton].forEach {
            audioTranscriptionContainerView.addArrangedSubview($0)
        }
        [
            chatWithRobotContainerView,
            imageGenerateContainerView,
            audioTranscriptionContainerView
        ].forEach {
            stackView.addArrangedSubview($0)
        }
        layoutConfigure()
    }

    private func layoutConfigure() {

        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }

        stackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }

        chatWithRobotText.snp.makeConstraints { make in
            make.height.equalTo(50)
        }

        chatWithRobotButtonTapped.snp.makeConstraints { make in
            make.height.equalTo(190)
        }

        imageGenerateText.snp.makeConstraints { make in
            make.height.equalTo(chatWithRobotText.snp.height)
        }

        imageGenerateButton.snp.makeConstraints { make in
            make.height.equalTo(chatWithRobotButtonTapped.snp.height)
        }

        audioTranscriptionText.snp.makeConstraints { make in
            make.height.equalTo(chatWithRobotText.snp.height)
        }

        audioTranscriptionButton.snp.makeConstraints { make in
            make.height.equalTo(chatWithRobotButtonTapped.snp.height)
        }
    }
}
