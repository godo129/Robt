//
//  SignUpViewController.swift
//  Robt
//
//  Created by hong on 2023/03/13.
//

import Combine
import SnapKit
import Then
import UIKit

final class SignUpViewController: UIViewController {

    private let viewModel: SignUpViewModel
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<SignUpViewModel.Input, Never> = .init()
    private let agreementViewConroller: AgreementViewController = .init()

    init(viewModel: SignUpViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var appleSignUpButton = UIButton().then {
        $0.setTitle("Apple로 시작하기", for: .normal)
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

    private lazy var emailSignUpButton = UIButton().then {
        $0.setTitle("이메일로 가입하기", for: .normal)
        $0.setTitleColor(.white, for: .normal)
        $0.setBackgroundColor(.blue, for: .normal)
        $0.setTitleColor(.white.withAlphaComponent(0.6), for: .highlighted)
        $0.setBackgroundColor(.blue.withAlphaComponent(0.6), for: .highlighted)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.titleLabel?.font = Font.bold(size: 18)
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
        output.receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                switch event {
                case .appleSignUpErrorOccured:
                    self?.presentOKAlert(title: "회원가입에 실패하셨습니다", message: "")
                    print("apple signUpErrorOcurred")
                }
            }
            .store(in: &cancellables)

        appleSignUpButton.tapPublisher.sink { [weak self] _ in
            guard let self else { return }
            self.present(self.agreementViewConroller, animated: true)
        }
        .store(in: &cancellables)

        agreementViewConroller.conformPublish.sink { [weak self] _ in
            guard let self else { return }
            self.agreementViewConroller.dismiss(animated: true)
            self.input.send(.appleButtonTap)
        }
        .store(in: &cancellables)
    }
}

extension SignUpViewController {
    private func configuration() {
        [appleSignUpButton].forEach {
            view.addSubview($0)
        }
    }

    private func layoutConfiguration() {
        appleSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }

//        emailSignUpButton.snp.makeConstraints { make in
//            make.top.equalTo(appleSignUpButton.snp.bottom).offset(32)
//            make.height.equalTo(50)
//            make.leading.trailing.equalToSuperview().inset(20)
//        }
    }
}
