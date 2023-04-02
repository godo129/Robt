//
//  AgreementViewController.swift
//  Robt
//
//  Created by hong on 2023/04/02.
//

import Combine
import SnapKit
import Then
import UIKit
import WebKit

final class AgreementViewController: UINavigationController {

    private lazy var termsOfUseView = WKWebView(frame: .zero)
    private lazy var conformButton = UIButton().then {
        $0.setTitle("확인", for: .normal)
        $0.setTitleColor(UIColor.black, for: .normal)
        $0.setBackgroundColor(.O007BFF, for: .normal)
        $0.setBackgroundColor(.O007BFF.withAlphaComponent(0.4), for: .highlighted)
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }

    private var cancellabels: Set<AnyCancellable> = .init()
    private let conformTapped: PassthroughSubject<Void, Never> = .init()
    var conformPublish: AnyPublisher<Void, Never> {
        conformTapped.eraseToAnyPublisher()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        bind()
        view.backgroundColor = .white
    }

    private func bind() {
        conformButton.tapPublisher
            .sink { [weak self] _ in
                self?.conformTapped.send(())
            }
            .store(in: &cancellabels)
    }
}

extension AgreementViewController {

    private func configure() {
        [termsOfUseView, conformButton].forEach {
            view.addSubview($0)
        }
        layoutConfigure()
        let url = URL(string: "https://brave-voyage-72f.notion.site/e5dcb864f35444db896ceb13e5349dd3")!
        let urlRequest = URLRequest(url: url)
        termsOfUseView.load(urlRequest)
    }

    private func layoutConfigure() {
        conformButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(20)
        }

        termsOfUseView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(conformButton.snp.top).inset(20)
        }
    }
}
