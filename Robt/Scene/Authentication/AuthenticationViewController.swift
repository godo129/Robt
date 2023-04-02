//
//  AuthenticationViewController.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import SnapKit
import Then
import UIKit

final class AuthenticationViewController: UIViewController {

    private let coordinator: AuthenticationCoordinator

    init(coordinator: AuthenticationCoordinator) {
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private lazy var homeImageView = UIImageView().then {
        $0.image = UIImage(named: "home.robot")
    }

    private lazy var signInButton = UIButton().then {
        $0.setTitle("로그인", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setBackgroundColor(.O007BFF, for: .normal)
        $0.setBackgroundColor(.O007BFF.withAlphaComponent(0.5), for: .highlighted)
        $0.setTitleColor(.black.withAlphaComponent(0.5), for: .highlighted)
        $0.clipsToBounds = true
        $0.layer.cornerRadius = 10
        $0.titleLabel?.font = Font.semiBold(size: 20)
    }

    private lazy var signUpButton = UIButton().then {
        $0.setTitle("회원가입", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setBackgroundColor(.O4CAF50, for: .normal)
        $0.setBackgroundColor(.O4CAF50.withAlphaComponent(0.5), for: .highlighted)
        $0.setTitleColor(.black.withAlphaComponent(0.5), for: .highlighted)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
        $0.titleLabel?.font = Font.semiBold(size: 20)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configuration()
        layoutConfiguration()
        buttonConfiguration()
    }
}

extension AuthenticationViewController {
    private func configuration() {
        view.backgroundColor = .white
        [homeImageView, signInButton, signUpButton].forEach {
            view.addSubview($0)
        }
    }

    private func layoutConfiguration() {

        homeImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(100)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(200)
        }

        signInButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.leading.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.5).inset(20)
        }
        signUpButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.width.equalToSuperview().multipliedBy(0.5).inset(20)
        }
    }

    private func buttonConfiguration() {
        signUpButton.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        signInButton.addTarget(self, action: #selector(signInButtonTapped), for: .touchUpInside)
    }

    @objc private func signUpButtonTapped() {
        coordinator.showSignUpViewController()
    }

    @objc private func signInButtonTapped() {
        coordinator.showSingInViewController()
    }
}
