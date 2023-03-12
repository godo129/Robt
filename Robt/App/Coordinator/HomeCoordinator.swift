//
//  HomeCoordinator.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import UIKit

protocol HomeCoordinatorDelegate: AnyObject {
    func finish(appMode: AppMode)
}

final class HomeCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: HomeCoordinatorDelegate?

    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
}

extension HomeCoordinator {

    func start() {}
}
