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
    
    let apiKey = "3cbb6b7e22aa7c5c3fd8b063d39ac3d5"
    
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
    
    func getWeatherDetail(capitalCity: String, completion: @escaping (City?, Error?) -> Void){
        let url = "https://api.openweathermap.org/data/2.5/weather"
        let params = [
            "q": capitalCity,
            "APPID": apiKey,
            "units": "metric"
        ]
        
        Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil).response { (response) in
            guard let data = response.data else {
                completion(nil, response.error)
                return
            }
            do{
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(City.self, from: data)
                completion(jsonData, nil)
            } catch{
                print("Failed to decode JSON")
            }
        }
    }
}
