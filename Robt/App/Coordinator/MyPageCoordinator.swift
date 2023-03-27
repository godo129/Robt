//
//  MyPageCoordinator.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import UIKit

final class MyPageCoordinator: TabProtocol {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    weak var delegate: TabDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
}

extension MyPageCoordinator {
    func start() {
        showMyPageViewController()
    }

    func showMyPageViewController() {
        let viewModel = MyPageViewModel(
            usecase: DependenciesContainer.share.resolve(MyPageViewUseCaseProtocol.self),
            coordinator: self
        )
        let viewController = MyPageViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
