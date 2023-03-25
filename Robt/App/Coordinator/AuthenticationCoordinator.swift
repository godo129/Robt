//
//  AuthenticationCoordinator.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import UIKit

protocol AuthenticationCoordinatorDelegate: AnyObject {
    func finish(appMode: AppMode)
}

final class AuthenticationCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    weak var delegate: AuthenticationCoordinatorDelegate?

    var navigationController: UINavigationController

    init(
        navigationController: UINavigationController
    ) {
        self.navigationController = navigationController
    }
}

extension AuthenticationCoordinator {
    func start() {
        showAuthentication()
    }

    func showAuthentication() {
        let authenticationViewController = AuthenticationViewController(coordinator: self)
        navigationController.pushViewController(authenticationViewController, animated: true)
    }

    func showSignUpViewController() {
        let signUpViewModel = SignUpViewModel(
            signUpViewUseCase: DependenciesContainer.share.resolve(SignUpViewUseCaseProtocol.self),
            coordinator: self
        )
        let signUpViewcontroller = SignUpViewController(viewModel: signUpViewModel)
        navigationController.pushViewController(signUpViewcontroller, animated: true)
    }

    func showSingInViewController() {
        let signInViewModel = SignInViewModel(
            usecase: DependenciesContainer.share.resolve(SignInViewUseCaseProtocol.self),
            coordinator: self
        )
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        navigationController.pushViewController(signInViewController, animated: true)
    }
}
