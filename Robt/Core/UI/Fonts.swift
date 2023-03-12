//
//  Fonts.swift
//  Robt
//
//  Created by hong on 2023/03/12.
//

import UIKit

enum Font: String {
    case regular = "NotoSans-Regular"
    case thin = "NotoSans-Thin"
    case medium = "NotoSans-Medium"
    case semiBold = "NotoSans-SemiBold"
    case bold = "NotoSans-Bold"

    func of(size: CGFloat) -> UIFont {
        return UIFont(name: rawValue, size: size)!
    }

    static func thin(size: CGFloat) -> UIFont {
        return Font.thin.of(size: size)
    }

    static func regular(size: CGFloat) -> UIFont {
        return Font.regular.of(size: size)
    }

    static func medium(size: CGFloat) -> UIFont {
        return Font.medium.of(size: size)
    }

    static func semiBold(size: CGFloat) -> UIFont {
        return Font.semiBold.of(size: size)
    }

    static func bold(size: CGFloat) -> UIFont {
        return Font.bold.of(size: size)
    }
}
