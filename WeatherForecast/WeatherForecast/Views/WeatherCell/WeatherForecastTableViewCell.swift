//
//  WeatherForecastTableViewCell.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 13.03.2025.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var infoView: WeatherInfoView!
    
    func config(with config: WeatherInfo) {
        infoView.config(with: config)
        dateLabel.text = "\(config.date)"
    }
}
