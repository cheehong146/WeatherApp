//
//  CityDetailVC.swift
//  WeatherApp
//
//  Created by Lan Chee Hong on 25/07/2019.
//  Copyright © 2019 Lan Chee Hong. All rights reserved.
//

import UIKit
import Alamofire

class CityDetailVC: UIViewController {
    @IBOutlet weak var ivBackground: UIImageView!
    //top container lbl
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblCountryCode: UILabel!
    @IBOutlet weak var lblTemperature: UILabel!
    @IBOutlet weak var lblDesc: UILabel!
    //middle container lbl
    @IBOutlet weak var lblSunrise: UILabel!
    @IBOutlet weak var lblSunset: UILabel!
    @IBOutlet weak var lblWindSpeedVal: UILabel!
    @IBOutlet weak var lblWindDegreeVal: UILabel!
    //static val lbl
    @IBOutlet weak var lblWindHeader: UILabel!
    @IBOutlet weak var lblWindSpeed: UILabel!
    @IBOutlet weak var lblWindDegree: UILabel!
    
    //all label array
    var allLabel = [UILabel]()
    
    var city: City?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allLabel = [
            lblCity, lblCountry, lblCountryCode,
            lblTemperature, lblDesc,
            lblSunrise, lblSunset,
            lblWindSpeedVal, lblWindDegreeVal,
            lblWindHeader, lblWindSpeed, lblWindDegree
        ]
        
        let userSelectedCity = "Moscow"
        
        
        fetchCityWeatherDetail(city: userSelectedCity)
        setBlurLayer()
    }
    
    fileprivate func fetchCityWeatherDetail(city: String){
        let param: Parameters = ["p": city, Constants.apiKeyParam: Constants.apiKey]
        let request = Alamofire.request(Constants.cityWeatherApi, method: .get, parameters: param, encoding: URLEncoding.queryString, headers: nil)
        request.responseJSON { (response) in
            switch response.result{
            case .success:
                do{
                    guard let json = response.data else {return}
                    let decoder = JSONDecoder()
                    self.city = try decoder.decode(City.self, from: json)
                    if let request = response.request {
                        print(request)
                    }
                    self.refershLayout()
                }catch {
                    print("Failed to decode json data \(error)")
                }
                break
            case .failure:
                break
            }
        }
    }
    
    fileprivate func refershLayout(){
        guard let city = city else {return}
        //background
        switch city.weather[0].main{
        case "Rain",
             "Thunderstorm":
            ivBackground.image = #imageLiteral(resourceName: "rainyBg")
        case "snow":
            ivBackground.image = #imageLiteral(resourceName: "snowBg")
                allLabel.forEach { (label) in
                    label.textColor = .black
            }
        default:
            ivBackground.image = #imageLiteral(resourceName: "sunBg")
        }
        //top container lbl
        lblCity.text = city.name
        lblCountry.text = city.sys.country
        lblCountryCode.text = "(\(123))"
        lblTemperature.text = "\(Int(city.main.temp))°C"
        lblDesc.text = city.weather[0].weatherDescription
        //middle container lbl
        lblSunrise.text = DateHelper.format(timeVal: city.sys.sunrise)
         lblSunset.text = DateHelper.format(timeVal: city.sys.sunset)
        lblWindSpeedVal.text = String(format: "%.2f", city.wind.speed)
        lblWindDegreeVal.text = String(format: "%.2f", city.wind.deg)
    }
    
    fileprivate func setBlurLayer(){
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
    }
}
