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

    func start() {
        let mode = modeChecker()
        start(appMode: mode)
    }

    private func start(appMode: AppMode) {
        guard childCoordinators.count == 2 else { return }
        childCoordinators[appMode.tag].start()
    }

    private func isAuthenticated() -> Bool {
        return false
    }

    private func modeChecker() -> AppMode {
        isAuthenticated() ? .home : .authentication
    }

    private func childCoordinatorConfiguration() {
        let authenticationCoordinator = AuthenticationCoordinator(navigationController: navigationController)
        authenticationCoordinator.delegate = self
        childCoordinators.append(authenticationCoordinator)

        let tabCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabCoordinator.delegate = self
        childCoordinators.append(tabCoordinator)
    }
}

extension RootCoordinator: AuthenticationCoordinatorDelegate, TaBarCoordinatorDelegate {

    func finish(appMode: AppMode) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.navigationController.viewControllers = []
            switch appMode {
            case .authentication:
                self.start(appMode: .home)
            case .home:
                self.start(appMode: .authentication)
            }
        }
    }
}
