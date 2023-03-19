//
//  SignUpViewController.swift
//  Robt
//
//  Created by hong on 2023/03/13.
//

import SnapKit
import Then
import UIKit

final class SignUpViewController: UIViewController {

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
    }
}

extension SignUpViewController {
    private func configuration() {
        [appleSignUpButton, emailSignUpButton].forEach {
            view.addSubview($0)
        }

        appleSignUpButton.addTarget(self, action: #selector(appleSignUpButtonPressed), for: .touchUpInside)
    }

    private func layoutConfiguration() {
        appleSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        emailSignUpButton.snp.makeConstraints { make in
            make.top.equalTo(appleSignUpButton.snp.bottom).offset(32)
            make.height.equalTo(50)
            make.leading.trailing.equalToSuperview().inset(20)
        }
    }

    @objc func appleSignUpButtonPressed() {
        let appleRepository = DependenciesContainer.share.resolve(AppleAuthenticationRepositoryProtocol.self)
        Task {
            do {
                let userID = try await appleRepository.signUp()
                print("userID is", userID)
            } catch {
                print(error)
            }
        }
    }
}
