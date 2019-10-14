//
//  String+Extension.swift
//  Mano
//
//  Created by Leandro Wauters on 9/28/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation

extension String {
        public func stringToDate() -> Date {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM d, h:mm a yyyy"
            dateFormatter.locale = .current
            guard let date = dateFormatter.date(from: self) else {
                return Date()
    //            fatalError()
            }
            return date
        }
}
