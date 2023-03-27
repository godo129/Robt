//
//  HomeViewController.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import SnapKit
import Then
import UIKit

final class HomeViewController: UIViewController {

    private lazy var chatRobotText = UITextView().then {
        $0.text = "로봇과 채팅하러가기!"
        $0.font = Font.semiBold(size: 20)
        $0.textColor = .black
    }

    private lazy var toRobotChatButton = UIButton().then {
        $0.setTitleColor(.black, for: .normal)
        $0.setImage(UIImage(named: "robot"), for: .normal)
        $0.setBackgroundColor(.OFFFFFF.withAlphaComponent(0.5), for: .highlighted)
        $0.layer.borderColor = UIColor.black.cgColor
        $0.layer.borderWidth = 2
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
    }
}

extension HomeViewController {
    private func configure() {
        [chatRobotText, toRobotChatButton].forEach {
            view.addSubview($0)
        }
        layoutConfigure()
    }

    private func layoutConfigure() {
        chatRobotText.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.leading.equalToSuperview().inset(50)
            make.width.lessThanOrEqualToSuperview()
            make.height.equalTo(30)
        }

        toRobotChatButton.snp.makeConstraints { make in
            make.top.equalTo(chatRobotText.snp.bottom).offset(20)
            make.leading.trailing.equalToSuperview().inset(50)
            make.height.equalTo(190)
        }
    }
}
