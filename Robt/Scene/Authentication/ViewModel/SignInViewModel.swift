//
//  SignInViewModel.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Combine
import Foundation

final class SignInViewModel: InputOutput {

    enum Input {}

    enum Output {}

    var cancellables: Set<AnyCancellable> = .init()

    var outPut: PassthroughSubject<Output, Never> = .init()

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never> {
        input.sink { event in
            switch event {}
        }
        .store(in: &cancellables)

        return outPut.eraseToAnyPublisher()
    }
}
