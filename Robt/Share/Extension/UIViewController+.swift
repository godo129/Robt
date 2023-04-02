//
//  UIViewController+.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import Combine
import UIKit

extension UIViewController {
    var keyboardHeightPublisher: AnyPublisher<CGFloat, Never> {
        let willShow = NotificationCenter.default.publisher(for: UIApplication.keyboardWillShowNotification)
            .map { ($0.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect)?.height ?? 0 }
        let willHide = NotificationCenter.default.publisher(for: UIApplication.keyboardWillHideNotification)
            .map { _ in CGFloat(0) }

        return willShow.merge(with: willHide)
            .eraseToAnyPublisher()
    }

    func viewPadding(
        top: CGFloat = 0,
        bottom: CGFloat = 0,
        leading: CGFloat = 0,
        trailing: CGFloat = 0
    ) {
        let size = UIScreen.main.bounds.size
        let origin = UIScreen.main.bounds.origin

        view.frame = CGRect(
            origin: CGPoint(x: origin.x + leading, y: origin.y + top),
            size: CGSize(width: size.width - leading - trailing, height: size.height - bottom)
        )
        UIView.animate(withDuration: 0.5, delay: 0.2) {}
    }

    func presentOKAlert(
        title: String?,
        message: String?,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: { _ in
            completion?()
        }))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }

    func presentConfirmationAlert(
        title: String?,
        message: String?,
        confirmTitle: String?,
        cancelTitle: String?,
        confirmAction: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil
    ) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: confirmTitle ?? "확인", style: .default, handler: { _ in
            confirmAction?()
        }))
        alert.addAction(UIAlertAction(title: cancelTitle ?? "취소", style: .cancel, handler: { _ in
            cancelAction?()
        }))
        DispatchQueue.main.async { [weak self] in
            self?.present(alert, animated: true, completion: nil)
        }
    }
}
