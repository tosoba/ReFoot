//
//  DateExt.swift
//  ReFoot
//
//  Created by merengue on 22/09/2018.
//  Copyright © 2018 merengue. All rights reserved.
//

import Foundation

extension Date {
    var dayOfTheWeek: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self)
    }
    
    func toStringYearMonthDay(separatedWith character: String = "-") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy\(character)MM\(character)dd"
        return dateFormatter.string(from: self)
    }
    
    func offsetBy(days: Int) -> Date {
        return Calendar.current.date(byAdding: .day, value: days, to: self)!
    }
    
    static var today: Date {
        return Date()
    }
}
