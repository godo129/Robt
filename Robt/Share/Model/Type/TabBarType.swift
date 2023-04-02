//
//  TabBarType.swift
//  Robt
//
//  Created by hong on 2023/03/26.
//

import UIKit

enum TabBarType: CaseIterable {
    case main
    case mypage

    var defaultImage: UIImage {
        switch self {
        case .main:
            return UIImage(systemName: "house")!
        case .mypage:
            return UIImage(systemName: "person")!
        }
    }

    var selectedImage: UIImage {
        switch self {
        case .main:
            return UIImage(systemName: "house")!
        case .mypage:
            return UIImage(systemName: "house")!
        }
    }

    var title: String {
        switch self {
        case .main:
            return "홈"
        case .mypage:
            return "마이페이지"
        }
    }
}
