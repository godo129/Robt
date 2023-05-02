//
//  HomeCoordinator.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import UIKit

protocol TabDelegate: AnyObject {
    func finish(tabType: TabBarType)
}

protocol TabProtocol: Coordinator {
    var delegate: TabDelegate? { get set }
}

final class MainCoordinator: TabProtocol {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    weak var delegate: TabDelegate?

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
        let viewModel = HomeViewModel(usecase: HomeViewUseCase(), coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showChatWithRobotViewController() {
        @DIContainer(ChatViewUsecaseProtocol.self) var usecase
        let viewModel = ChatWithRobotViewModel(useCase: usecase, coordinator: self)
        let viewController = ChatWithRobotViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }

    func showImageGenerateViewController() {
        @DIContainer(ImageGenerateViewUseCaseProtocol.self) var usecase
        let viewModel = ImageGenerateViewModel(usecase: usecase, coordinator: self)
        let viewController = ImageGenerateViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func showAudioTranscriptionViewController() {
        @DIContainer(AudioTranscriptionViewUsecaseProtocol.self) var usecase
        let viewModel = AudioTrnascriptionViewModel(usecase: usecase, coordinator: self)
        let viewController = AudioTranscriptionViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}
