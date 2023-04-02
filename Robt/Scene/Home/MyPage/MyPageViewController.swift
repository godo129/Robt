//
//  MyPageViewController.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Combine
import SnapKit
import Then
import UIKit

final class MyPageViewController: UIViewController {

    private let viewModel: MyPageViewModel
    private var cancellables = Set<AnyCancellable>()
    private let input: PassthroughSubject<MyPageViewModel.Input, Never> = .init()

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

    init(viewModel: MyPageViewModel) {
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

    private func bind() {

        let output = viewModel.transform(input: input.eraseToAnyPublisher())
        output.sink { event in
            switch event {
            case .signOutError:
                print("로그아웃 에러")
            case .withdrawalError:
                print("회원 탈퇴 에러")
            }
        }
        .store(in: &cancellables)

        signOutButton.tapPublisher.sink { [weak self] _ in
            self?.presentConfirmationAlert(
                title: "로그아웃 하시겠습니까?",
                message: "",
                confirmTitle: "확인",
                cancelTitle: "취소",
                confirmAction: {
                    self?.input.send(.signOutButtonTapped)
                }
            )
        }
        .store(in: &cancellables)

        withdrawalButton.tapPublisher.sink { [weak self] _ in
            self?.presentConfirmationAlert(
                title: "회원 탈퇴하시겠습니가?",
                message: "이전까지 있던 정보가 전부 사라집니다",
                confirmTitle: "확인",
                cancelTitle: "취소",
                confirmAction: {
                    self?.input.send(.withdrawalButtonTapped)
                }
            )
        }
        .store(in: &cancellables)
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
