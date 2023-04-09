//
//  HomeCoordinator.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import UIKit

protocol TabDelegate: AnyObject {
    func finish(tabType: TabBarType)
}

protocol TabProtocol: Coordinator {
    var delegate: TabDelegate? { get set }
}

final class MainCoordinator: TabProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: TabDelegate?

    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
}

extension MainCoordinator {

    func start() {
        showHomeViewController()
    }

    func showHomeViewController() {
        let viewModel = HomeViewModel(usecase: HomeViewUseCase(), coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showChatWithRobotViewController() {
        let usecase = DependenciesContainer.share.resolve(ChatViewUsecaseProtocol.self)
        let viewModel = ChatWithRobotViewModel(useCase: usecase, coordinator: self)
        let viewController = ChatWithRobotViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
