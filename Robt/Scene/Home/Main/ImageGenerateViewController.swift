//
//  ImageGenerateViewController.swift
//  Robt
//
//  Created by hong on 2023/05/01.
//

import Combine
import UIKit

final class ImageGenerateViewController: UIViewController {

    private lazy var scrollView = UIScrollView()
    private lazy var stackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fill
        $0.spacing = 50
    }

    private lazy var promptView = UIView()
    private lazy var emptyView = UIView()

    private lazy var promptTextField = CommentTextField(left: 20, right: 20).then {
        $0.backgroundColor = .white
        $0.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        $0.layer.cornerRadius = 20
        $0.layer.borderColor = UIColor.purple.cgColor
        $0.layer.borderWidth = 2
        $0.placeholder = "Enter Prompt"
        $0.autocorrectionType = .no
    }

    private lazy var promptButton = UIButton().then {
        $0.layer.cornerRadius = 10
        $0.setTitle("생성", for: .normal)
        $0.setTitleColor(.OFFFFFF, for: .normal)
        $0.setTitleColor(.OFFFFFF.withAlphaComponent(0.6), for: .highlighted)
        $0.setBackgroundColor(.O000000, for: .normal)
        $0.setBackgroundColor(.O000000.withAlphaComponent(0.6), for: .highlighted)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.titleLabel?.font = Font.bold(size: 18)
    }

    private lazy var imageView = UIImageView().then {
        $0.image = UIImage(named: "emptyImage")
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.contentMode = .scaleAspectFill
        $0.contentMode = .top
    }

    private lazy var activityIndicator: UIActivityIndicatorView = .init(style: .large)

    private let viewModel: ImageGenerateViewModel
    private var input: PassthroughSubject<ImageGenerateViewModel.Input, Never> = .init()
    private var cancellabels: Set<AnyCancellable> = .init()

    init(viewModel: ImageGenerateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "이미지 생성"
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
    }
}

extension ImageGenerateViewController {
    private func bind() {
        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { [weak self] event in
            guard let self else { return }
            switch event {
            case let .imageGenerated(imageData):
                let image = UIImage(data: imageData)
                DispatchQueue.main.async {
                    self.imageView.image = image
                    self.indicatorBlock(false)
                }
            case .imageGenerateFailed:
                self.presentOKAlert(title: "이미지 생성에 실패하였습니다", message: "입력을 다시 해주세요")
                self.indicatorBlock(false)
            }
        }
        .store(in: &cancellabels)

        promptButton.tapPublisher.sink { [weak self] _ in
            guard let self else { return }
            guard let prompt = self.promptTextField.text else { return }
            self.promptTextField.resignFirstResponder()
            self.input.send(.imagePromptInputted(prompt))
            self.indicatorBlock(true)
        }
        .store(in: &cancellabels)

        promptTextField.inputPublish.sink { [weak self] prompt in
            guard let self else { return }
            self.promptTextField.resignFirstResponder()
            self.input.send(.imagePromptInputted(prompt))
            self.indicatorBlock(true)
        }
        .store(in: &cancellabels)
    }

    private func configure() {
        view.backgroundColor = .white
        tabBarController?.setTabBarVisible(visible: false, duration: 0, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)

        view.addSubview(scrollView)
        view.addSubview(activityIndicator)
        scrollView.addSubview(stackView)
        [promptTextField, promptButton].forEach {
            promptView.addSubview($0)
        }
        [promptView, imageView].forEach {
            stackView.addArrangedSubview($0)
        }
        layoutConfigure()
        inidicatorConfigure()
        keyboardConfigure()
    }

    private func layoutConfigure() {
        scrollView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
        stackView.snp.makeConstraints { make in
            make.edges.width.equalToSuperview()
        }
        promptView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(50)
        }
        promptTextField.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalToSuperview().inset(50)
            make.trailing.equalToSuperview().inset(150)
        }
        promptButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading.equalTo(promptTextField.snp.trailing).offset(20)
            make.trailing.equalToSuperview().inset(50)
        }
        imageView.snp.makeConstraints { make in
            make.top.equalTo(promptView.snp.bottom).offset(50)
            make.leading.trailing.equalToSuperview().inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
    }

    private func inidicatorConfigure() {
        activityIndicator.center = view.center
    }

    private func indicatorBlock(_ block: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            if block {
                self.view.isUserInteractionEnabled = false
                self.view.alpha = 0.3
                self.activityIndicator.startAnimating()
            } else {
                self.view.isUserInteractionEnabled = true
                self.view.alpha = 1.0
                self.activityIndicator.stopAnimating()
            }
        }
    }

    private func keyboardConfigure() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(resignResponder))
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func resignResponder() {
        view.endEditing(true)
    }
}
