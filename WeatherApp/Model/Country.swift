//
//  Country.swift
//  WeatherApp
//
//  Created by Nate Goh on 24/07/2019.
//  Copyright © 2019 Lan Chee Hong. All rights reserved.
//

import Foundation

class Country {
    var name: String
    var capital: String

    init?(json: [String: Any]) {
    guard
        let name: String = json["name"] as? String,
        let capital: String = json["capital"] as? String
        else {
            print("Error while fetching countries data.")
            return nil
        }

        self.name = name
        self.capital = capital
    }
}
