//
//  UITextField+.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Combine
import UIKit

extension UITextField {
    var inputPublish: AnyPublisher<String, Never> {
        controlPublisher(for: .editingDidEndOnExit)
            .compactMap { $0 as? UITextField }
            .map { $0.text ?? "" }
            .eraseToAnyPublisher()
    }
}
