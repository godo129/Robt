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
    
    enum Mode {
        case authentication
        case mainView
    }
    
    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
}

extension RootCoordinator {
    func start() {
        
    }
    
    func isAuthenticated() -> Mode {
        return .authentication
    }
}
