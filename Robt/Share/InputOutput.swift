//
//  InputOutput.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import Combine
import Foundation

protocol InputOutput {
    associatedtype Input
    associatedtype Output

    var outPut: PassthroughSubject<Output, Never> { get }
    var cancellables: Set<AnyCancellable> { get }

    func transform(input: AnyPublisher<Input, Never>) -> AnyPublisher<Output, Never>
}
