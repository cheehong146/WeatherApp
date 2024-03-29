//
//  CityDetailVC.swift
//  WeatherApp
//
//  Created by Lan Chee Hong on 25/07/2019.
//  Copyright © 2019 Lan Chee Hong. All rights reserved.
//

import UIKit
import Alamofire
import CoreImage
import MBProgressHUD

class CityDetailVC: UIViewController {
    @IBOutlet weak var ivBackground: UIImageView!
    //top container lbl
    @IBOutlet weak var lblCity: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
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
    
    var progressHUD: MBProgressHUD?
    
    //all label array
    var allLabel = [UILabel]()
    
    var queryTxt: String?
    var countryCode: String {
        if let country = country {
            return country.code
        }
        return "123"
    }
    var city: City?
    var country: Country?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        allLabel = [
            lblCity, lblCountry,
            lblTemperature, lblDesc,
            lblSunrise, lblSunset,
            lblWindSpeedVal, lblWindDegreeVal,
            lblWindHeader, lblWindSpeed, lblWindDegree
        ]
        
        self.title = queryTxt!
        self.lblCity.text = country?.capital
        self.lblCountry.text = "\(country?.name ?? "KL") (\(country?.code ?? "123"))"
        blurEffect(imageView: self.ivBackground)
        
        fetchCityWeatherDetail(city: queryTxt!)
    }
    
    fileprivate func fetchCityWeatherDetail(city: String){
        progressHUD? = MBProgressHUD(view: self.view)
        progressHUD?.mode = .indeterminate
        progressHUD?.isUserInteractionEnabled = false
        progressHUD?.label.text = "Loading..."
        progressHUD?.show(animated: true)
        MBProgressHUD.showAdded(to: self.view, animated: true)
        NetworkingController.sharedInstance.getWeatherDetail(capitalCity: city) { (city, error) in
            if let city = city {
                self.city = city
                self.refershLayout()
            }
            
            if let error = error{
                print(error)
            }
            
            MBProgressHUD.hide(for: self.view, animated: true)
        }
    }
    
    fileprivate func refershLayout(){
        guard let city = city else {return}
        //background
        switch city.weather[0].main{
        case "Rain",
             "Thunderstorm":
            ivBackground.image = #imageLiteral(resourceName: "rainyBg")
        case "snow", "Snow":
            ivBackground.image = #imageLiteral(resourceName: "snowBg")
                allLabel.forEach { (label) in
                    label.textColor = .black
            }
        default:
            ivBackground.image = #imageLiteral(resourceName: "sunBg")
        }
        
        //blur the bg image
        blurEffect(imageView: ivBackground)
        
        //top container lbl
//        lblCity.text = city.name
//        lblCountry.text = city.sys.country
 
        //        lblCountryCode.text = "(\(countryCode))"
        lblTemperature.text = "\(Int(city.main.temp))°C"
        lblDesc.text = city.weather[0].weatherDescription
        //middle container lbl
        lblSunrise.text = DateHelper.format(timeVal: city.sys.sunrise)
         lblSunset.text = DateHelper.format(timeVal: city.sys.sunset)
        lblWindSpeedVal.text = String(format: "%.2f", city.wind.speed)
        lblWindDegreeVal.text = String(format: "%.2f", city.wind.deg)
    }
    
    fileprivate func blurEffect(imageView: UIImageView) {
        
        let context = CIContext(options: nil)
        
        let currentFilter = CIFilter(name: "CIGaussianBlur")
        let beginImage = CIImage(image: imageView.image!)
        currentFilter!.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter!.setValue(5, forKey: kCIInputRadiusKey)
        
        let cropFilter = CIFilter(name: "CICrop")
        cropFilter!.setValue(currentFilter!.outputImage, forKey: kCIInputImageKey)
        cropFilter!.setValue(CIVector(cgRect: beginImage!.extent), forKey: "inputRectangle")
        
        let output = cropFilter!.outputImage
        let cgimg = context.createCGImage(output!, from: output!.extent)
        let processedImage = UIImage(cgImage: cgimg!)
        imageView.image = processedImage
    }
}
