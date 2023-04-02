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
        navigationController.isNavigationBarHidden = true
        tabBarController.tabBar.layer.borderColor = UIColor.gray.cgColor
        tabBarController.tabBar.layer.borderWidth = 1
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
        tabBarController.view.backgroundColor = .white
        tabBarController.tabBar.backgroundColor = .white
        tabBarController.tabBar.isTranslucent = false
    }

    private func createTabNavigationController(tabBarType: TabBarType) -> UINavigationController {
        let tabNavigationController = UINavigationController()
        let coordinator: TabProtocol
        switch tabBarType {
        case .main:
            coordinator = MainCoordinator(navigationController: tabNavigationController)
        case .mypage:
            coordinator = MyPageCoordinator(navigationController: tabNavigationController)
        }
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()

        tabNavigationController.tabBarItem = UITabBarItem(
            title: tabBarType.title,
            image: tabBarType.defaultImage,
            selectedImage: tabBarType.defaultImage
        )

        return tabNavigationController
    }
}

extension TabBarCoordinator: TabDelegate {
    func finish(tabType: TabBarType) {
        switch tabType {
        case .main:
            delegate?.finish(appMode: .home)
        case .mypage:
            delegate?.finish(appMode: .home)
        }
    }
}
