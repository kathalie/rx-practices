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
    
    func config(with config: DayWeatherForecast) {
        dayInfoView.config(with: config.dayForecast)
        nightInfoView.config(with: config.nightForecast)
        dateLabel.text = "\(config.date)"
    }
}
