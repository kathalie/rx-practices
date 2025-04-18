//
//  HalfDayWeatherForecast.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 14.04.2025.
//

import Foundation

struct HalfDayWeatherForecast: Hashable {
    let iconId: String
    let temperature: Double
    let weatherCondition: String
    let windSpeed: Double
    let rainMm: Double
    
    init?(from model: DayForecastModel){
        guard
            let iconId = model.weather.first?.icon,
            let weatherCondition = model.weather.first?.main
        else { return nil }
            
        self.iconId = iconId
        self.temperature = model.main.temp
        self.weatherCondition = weatherCondition
        self.windSpeed = model.wind.speed
        self.rainMm = model.rain?.threeHours ?? 0
    }
}
