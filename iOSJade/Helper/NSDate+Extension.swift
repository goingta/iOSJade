//
//  NSDate+Extension.swift
//  iOSJade
//
//  Created by goingta on 2019/8/26.
//  Copyright © 2019 goingta. All rights reserved.
//

import Foundation

extension Date {
    func toString(dateFormat format: String ) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = NSLocale.system
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
