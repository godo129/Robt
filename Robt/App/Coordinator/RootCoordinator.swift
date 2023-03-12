//
//  RootCoordinator.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import UIKit

protocol Coordinator: AnyObject {
    var childCoordinators: [Coordinator] { get set }
    var navigationController: UINavigationController { get set }
    func start()
}

final class RootCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
        childCoordinatorConfiguration()
    }
}

extension RootCoordinator {

    func start() {}

    func start(appMode _: AppMode) {}

    func isAuthenticated() -> AppMode {
        return .authentication
    }

    private func childCoordinatorConfiguration() {
        let authenticationCoordinator = AuthenticationCoordinator(navigationController: navigationController)
        authenticationCoordinator.delegate = self
        childCoordinators.append(authenticationCoordinator)

        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.delegate = self
        childCoordinators.append(homeCoordinator)
    }
}

extension RootCoordinator: AuthenticationCoordinatorDelegate, HomeCoordinatorDelegate {

    func finish(appMode: AppMode) {
        switch appMode {
        case .authentication:
            start(appMode: .home)
        case .home:
            start(appMode: .authentication)
        }
    }
}
