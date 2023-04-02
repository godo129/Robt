//
//  Date+.swift
//  Robt
//
//  Created by hong on 2023/04/02.
//

import Foundation

extension Date {
    var toTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let timeStampString = formatter.string(from: self)
        return timeStampString
    }
}
