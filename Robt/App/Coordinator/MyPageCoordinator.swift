//
//  MyPageCoordinator.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import UIKit

protocol MyPageCoordinatorDelegate: AnyObject {
    func finish(tap: TabBarType)
}

final class MyPageCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []

    var navigationController: UINavigationController
    weak var delegate: MyPageCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
}

extension MyPageCoordinator {
    func start() {
        showMyPageViewController()
    }

    func showMyPageViewController() {
        let viewController = MyPageViewController()
        navigationController.pushViewController(viewController, animated: true)
    }
}
