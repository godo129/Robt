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
        
    }
    
    func start(appMode: AppMode) {
        
    }
    
    func isAuthenticated() -> AppMode {
        return .authentication
    }
    
    private func childCoordinatorConfiguration() {
        let authenticationCoordinator = AuthenticationCoordinator(navigationController: navigationController)
        authenticationCoordinator.delegate = self
        childCoordinators.append(authenticationCoordinator)
    }
}

extension RootCoordinator: AuthenticationCoordinatorDelegate {
    func finish(appMode: AppMode) {
        switch appMode {
        case .authentication:
            start(appMode: .main)
        case .main:
            start(appMode: .authentication)
        }
    }
}
