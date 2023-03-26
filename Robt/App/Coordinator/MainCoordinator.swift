//
//  HomeCoordinator.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import UIKit

protocol MainCoordinatorDelegate: AnyObject {
    func finish(tab: TabBarType)
}

final class MainCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: MainCoordinatorDelegate?

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
        let homeViewController = HomeViewController()
        navigationController.pushViewController(homeViewController, animated: true)
    }
}
