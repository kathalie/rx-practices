//
//  DayWeatherForecast.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 14.04.2025.
//

import Foundation

struct DayWeatherForecast: Hashable {
    let date: String
    let dayForecast: HalfDayWeatherForecast
    let nightForecast: HalfDayWeatherForecast
}
