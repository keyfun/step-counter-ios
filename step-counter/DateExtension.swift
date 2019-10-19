//
//  DateExtension.swift
//  step-counter
//
//  Created by Key Hui on 10/19/19.
//  Copyright © 2019 keyfun. All rights reserved.
//

import Foundation

extension Date {
    var formattedDate: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        return dateFormatter.string(from: self)
    }
}
