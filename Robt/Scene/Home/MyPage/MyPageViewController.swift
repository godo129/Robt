//
//  MyPageViewController.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import SnapKit
import Then
import UIKit

final class MyPageViewController: UIViewController {

    private lazy var signOutButton = UIButton().then {
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.black.withAlphaComponent(0.5), for: .highlighted)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = Font.semiBold(size: 20)
    }

    private lazy var withdrawalButton = UIButton().then {
        $0.setTitle("회원탈퇴", for: .normal)
        $0.setTitleColor(.black, for: .normal)
        $0.setTitleColor(.black.withAlphaComponent(0.5), for: .highlighted)
        $0.backgroundColor = .clear
        $0.titleLabel?.font = Font.semiBold(size: 20)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
}

extension MyPageViewController {
    func configure() {
        [signOutButton, withdrawalButton].forEach {
            view.addSubview($0)
        }
        configureLayout()
    }

    func configureLayout() {
        signOutButton.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(32)
            make.leading.equalToSuperview().inset(40)
        }

        withdrawalButton.snp.makeConstraints { make in
            make.top.equalTo(signOutButton.snp.bottom).offset(20)
            make.leading.equalTo(signOutButton.snp.leading)
        }
    }
}
