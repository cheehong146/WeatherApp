//
//  NoResultTableViewCell.swift
//  WeatherApp
//
//  Created by Nate Goh on 25/07/2019.
//  Copyright © 2019 Lan Chee Hong. All rights reserved.
//

import UIKit

class NoResultTableViewCell: UITableViewCell {

    @IBOutlet weak var suggestionLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.suggestionLabel.text = "Hmmm, we're not getting any results.\nTry another search"
        self.backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
