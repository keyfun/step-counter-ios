//
//  AppUtils.swift
//  step-counter
//
//  Created by Key Hui on 10/19/19.
//  Copyright © 2019 keyfun. All rights reserved.
//

import Foundation

struct AppUtils {

    static func getFormattedDate(_ date: Date?) -> String {
        guard let date = date else {
            return ""
        }
        return date.formattedDate
    }
}
