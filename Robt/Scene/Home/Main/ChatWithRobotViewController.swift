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

    private let chattingTableView: UITableView = .init()
    private let chatTextField: UITextField = .init()

    private let messages: [String] = ["ewafwefe", "awefwaeeawaefawefwewfewefaewfewfwee", "testetsesetsteetaetetwtwtewtawetaw\nawetweat\nwaetwaet\ntaeeat"]

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configure()
        chattingTableView.reloadData()
    }
}

extension ChatWithRobotViewController {
    func configure() {
        [chattingTableView].forEach {
            view.addSubview($0)
        }

        chattingTableView.register(
            ChatTableViewCell.self,
            forCellReuseIdentifier: ChatTableViewCell.identifier
        )
        layoutConfigure()
        chattingTableView.delegate = self
        chattingTableView.dataSource = self
    }

    func layoutConfigure() {
        chattingTableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
        }
    }
}

extension ChatWithRobotViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ChatTableViewCell.identifier,
            for: indexPath
        ) as? ChatTableViewCell else {
            return UITableViewCell()
        }
        let message = messages[indexPath.row]
        print(message)
        cell.configure(with: message)
        return cell
    }
}
