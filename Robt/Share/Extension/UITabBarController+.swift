//
//  UITabBarController+.swift
//  Robt
//
//  Created by hong on 2023/04/01.
//

import UIKit

extension UITabBarController {
    func setTabBarVisible(visible: Bool, duration: TimeInterval, animated _: Bool) {
        if tabBarIsVisible() == visible { return }
        let frame = tabBar.frame
        let height = frame.size.height
        let offsetY = (visible ? -height : height)

        // animation
        UIViewPropertyAnimator(duration: duration, curve: .linear) {
            self.tabBar.frame.offsetBy(dx: 0, dy: offsetY)
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height + offsetY)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }.startAnimation()
    }

    func tabBarIsVisible() -> Bool {
        return tabBar.frame.origin.y < UIScreen.main.bounds.height
    }
}
