//
//  TabBarCoordinator.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import UIKit

protocol TaBarCoordinatorDelegate: AnyObject {
    func finish(appMode: AppMode)
}

final class TabBarCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    let tabBarController = UITabBarController()
    weak var delegate: TaBarCoordinatorDelegate?

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.isNavigationBarHidden = true
    }
}

extension TabBarCoordinator {
    func start() {
        configureTabBarController()
    }

    private func configureTabBarController() {
        let navigationControllers = TabBarType.allCases.map {
            createTabNavigationController(tabBarType: $0)
        }
        tabBarController.viewControllers = navigationControllers
        navigationController.viewControllers = [tabBarController]

        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.isTranslucent = false
    }

    private func createTabNavigationController(tabBarType: TabBarType) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        let coordinator: Coordinator
        switch tabBarType {
        case .main:
            coordinator = MainCoordinator(navigationController: tabNavigationController)
            coordinator.start()
        case .mypage:
            coordinator = MyPageCoordinator(navigationController: tabNavigationController)
        }
//        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()

        tabNavigationController.tabBarItem = UITabBarItem(
            title: nil,
            image: tabBarType.defaultImage,
            selectedImage: tabBarType.defaultImage
        )

        return tabNavigationController
    }
}
