//
//  SignInViewController.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Combine
import UIKit

class SignInViewController: UIViewController {

    private let viewModel: SignInViewModel
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<SignInViewModel.Input, Never> = .init()

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var appleSignInButton = UIButton().then {
        $0.setTitle("Apple로 로그인", for: .normal)
        $0.setTitleColor(.OFFFFFF, for: .normal)
        $0.setBackgroundColor(.O000000, for: .normal)
//        $0.setTitleColor(.OFFFFFF.withAlphaComponent(0.6), for: .highlighted)
//        $0.setBackgroundColor(.O000000.withAlphaComponent(0.6), for: .highlighted)
        $0.titleLabel?.textAlignment = .center
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.titleLabel?.font = Font.bold(size: 18)
        $0.setImage(UIImage(named: "ic.apple.logo"), for: .normal)
//        $0.setImage(UIImage(named: "ic.apple.logo")?.imageByAddingAlpha(0.1), for: .highlighted)
        $0.imageView?.contentMode = .scaleAspectFit
        $0.contentHorizontalAlignment = .center
        $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        $0.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configuration()
        layoutConfiguration()
        bind()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    private func bind() {

        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { [weak self] event in
            switch event {
            case .signInError:
                self?.presentOKAlert(
                    title: "로그인에 실패했습니다",
                    message: ""
                )
            }
        }
        .store(in: &cancellables)

        appleSignInButton.tapPublisher.sink { [weak self] _ in
            self?.input.send(.appleSignInButtonTapped)
        }
        .store(in: &cancellables)
    }
}

extension SignInViewController {
    private func configuration() {
        [appleSignInButton].forEach {
            view.addSubview($0)
        }
    }

    private func layoutConfiguration() {
        appleSignInButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }
}
