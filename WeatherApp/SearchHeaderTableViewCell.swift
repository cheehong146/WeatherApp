//
//  SearchHeaderTableViewCell.swift
//  WeatherApp
//
//  Created by Nate Goh on 25/07/2019.
//  Copyright © 2019 Lan Chee Hong. All rights reserved.
//

import UIKit

class SearchHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func set(text: String, imageName: String) {
        self.headerLabel.text = text
        self.iconImageView.image = UIImage(named: imageName)
    }
}
