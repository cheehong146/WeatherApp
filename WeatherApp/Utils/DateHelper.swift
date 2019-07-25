//
//  DateHelper.swift
//  WeatherApp
//
//  Created by Lan Chee Hong on 25/07/2019.
//  Copyright © 2019 Lan Chee Hong. All rights reserved.
//

import Foundation

class DateHelper{
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter
    }()
    
    static func format(timeVal: Int) -> String{
        guard let time = TimeInterval(exactly: timeVal) else {return "Invalid"}

        return dateFormatter.string(from: Date(timeIntervalSince1970: time))
    }
}
