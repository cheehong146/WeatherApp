//
//  HomeVC.swift
//  WeatherApp
//
//  Created by Lan Chee Hong on 25/07/2019.
//  Copyright © 2019 Lan Chee Hong. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var tfSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "WeatherApp"
        roundSearchButton()

    }
    
    @IBAction func onBtnSearchPressed(_ sender: Any) {
        let inputTxt = tfSearch.text
        
        if inputTxt == "" {
                        let alertController = UIAlertController(title: "Alert", message: "Please fill in country city", preferredStyle: .alert)
            alertController.addAction(UIAlertAction.init(title: "Dismiss", style: .default, handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            let searchVC = SearchResultVC(nibName: "SearchResultVC", bundle: nil)
            guard let inputCity = inputTxt else {return}
            searchVC.searchText = inputCity
            
            self.navigationController?.pushViewController(searchVC, animated: true)
        }
    }
    
    fileprivate func roundSearchButton(){
        btnSearch.layer.cornerRadius = 8
    }
}
