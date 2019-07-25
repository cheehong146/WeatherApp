//
//  NetworkingController.swift
//  WeatherApp
//
//  Created by Nate Goh on 24/07/2019.
//  Copyright © 2019 Lan Chee Hong. All rights reserved.
//

import Foundation
import Alamofire

class NetworkingController  {
    static let sharedInstance = NetworkingController()

    private init() {}

    func getWeatherResult(completion: @escaping ([Country]?,Error?) -> Void) {
        let url = "https://restcountries.eu/rest/v2/all"
        Alamofire.request(url, method: .get, encoding: URLEncoding.default, headers: nil).responseJSON { (response) in
            guard response.result.isSuccess
            else {
                completion(nil, response.error)
                    return
            }

            guard let data = response.result.value as? [[String: Any]]
                else {
                    completion(nil, response.error)
                    return
            }
            var countries: [Country] = []
            for country in data {
                if let countryObject: Country = Country(json: country) {
                    countries.append(countryObject)
                }
            }
            completion(countries, nil)
        }
    }
}
