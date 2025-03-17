//
//  WeatherForecastTableViewCell.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 13.03.2025.
//

import UIKit

class WeatherForecastTableViewCell: UITableViewCell {
    @IBOutlet private weak var dateLabel: UILabel!
    @IBOutlet private weak var dayInfoView: WeatherInfoView!
    @IBOutlet private weak var nightInfoView: WeatherInfoView!
    
    func config(with config: WeatherInfo) {
        dayInfoView.config(with: config)
        nightInfoView.config(with: config)
        dateLabel.text = "\(config.date)"
    }
}
