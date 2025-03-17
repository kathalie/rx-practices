//
//  Models.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import Foundation

struct WeekWeatherForecastModel: Decodable {
    let list: [DayForecastModel]
}

struct DayForecastModel: Decodable {
    let dt: Int
    let main: DayForecastMainModel
    let weather: [DayForecastWeatherModel]
    let wind: DayForecastWindModel
    let rain: DayForecastRainModel?
}

struct DayForecastMainModel: Decodable {
    let temp: Double
}

struct DayForecastWeatherModel: Decodable {
    let main: String
    let icon: String
}

struct DayForecastWindModel: Decodable {
    let speed: Double
}

struct DayForecastRainModel: Decodable {
    let threeHours: Double

    enum CodingKeys: String, CodingKey {
        case threeHours = "3h"
    }
}
