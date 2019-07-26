//
//  SearchResultVC.swift
//  WeatherApp
//
//  Created by Nate Goh on 24/07/2019.
//  Copyright © 2019 Lan Chee Hong. All rights reserved.
//

import UIKit

class SearchResultVC: UIViewController, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {

    private enum ResultType: Int {
        case country = 0, city, noResult

        static let count: Int = 3
    }

    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    var searchText: String = ""
    var countries: [Country] = []
    var foundCountries: [String] = []
    var foundCities: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.register(UINib.init(nibName: "NoResultTableViewCell", bundle: nil), forCellReuseIdentifier: "NoResultTableViewCell")
        tableView.register(UINib.init(nibName: "SearchHeaderTableViewCell", bundle: nil), forCellReuseIdentifier: "SearchHeaderTableViewCell")
        fetchCountryData()
    }

    func fetchCountryData() {
        self.tableView.isHidden = true
        self.loadingView.isHidden = false
        self.loadingView.startAnimating()
        NetworkingController.sharedInstance.getWeatherResult { (countries:[Country]?, error: Error?) in
            if let _ = error {
                self.loading()
                self.loadingView.stopAnimating()
            }
            if let countries = countries {
                self.countries = countries
            }
            self.filterSearchResult(searchText: self.searchText)
            self.loading()
            self.loadingView.stopAnimating()
        }
    }

    func loading() {
        self.tableView.isHidden = !self.tableView.isHidden
        self.loadingView.isHidden = !self.loadingView.isHidden
    }

    func filterSearchResult(searchText: String) {
        self.foundCountries = []
        self.foundCities = []
        for country in countries {
            if country.name.contains(searchText) {
                self.foundCountries.append(country.name)
            }
            if country.capital.contains(searchText) {
                self.foundCities.append(country.capital)
            }
        }
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case ResultType.country.rawValue:
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "CountryTableViewCell")
            cell.textLabel?.text = foundCountries[indexPath.row]
            cell.backgroundColor = .clear
            return cell
        case ResultType.city.rawValue:
            let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "CapitalTableViewCell")
            cell.textLabel?.text = foundCities[indexPath.row]
            cell.backgroundColor = .clear
            return cell
        case ResultType.noResult.rawValue:
            let cell: NoResultTableViewCell = tableView.dequeueReusableCell(withIdentifier: "NoResultTableViewCell", for: indexPath) as! NoResultTableViewCell
            return cell
        default:
            return UITableViewCell()
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case ResultType.country.rawValue:
            return foundCountries.count
        case ResultType.city.rawValue:
            return foundCities.count
        case ResultType.noResult.rawValue:
            return (foundCountries.isEmpty && foundCities.isEmpty) ? 1 : 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell :SearchHeaderTableViewCell = tableView.dequeueReusableCell(withIdentifier: "SearchHeaderTableViewCell") as! SearchHeaderTableViewCell
        switch section {
        case ResultType.country.rawValue: cell.set(text: "Country", imageName: "ic_country")
        case ResultType.city.rawValue: cell.set(text: "City", imageName: "ic_city")
        default: cell.set(text: "", imageName: "")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case ResultType.country.rawValue:
            return !foundCountries.isEmpty ? 40 : 0
        case ResultType.city.rawValue:
            return !foundCities.isEmpty ? 40 : 0
        default:
            return 0
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case ResultType.noResult.rawValue:
            return tableView.frame.height
        default:
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        let selectedTxt = cell?.textLabel?.text
        goToDetailWeatherVC(queryTxt: selectedTxt!, countryCode: "999")
    }
    
    fileprivate func goToDetailWeatherVC(queryTxt: String, countryCode: String){
        let detailWeatherVC = CityDetailVC(nibName: "CityDetailVC", bundle: nil)
        detailWeatherVC.queryTxt = queryTxt
        detailWeatherVC.countryCode = countryCode
        self.navigationController?.pushViewController(detailWeatherVC, animated: true)
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return ResultType.count
    }
}
