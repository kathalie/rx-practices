//
//  Models.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import Foundation

struct WeekWeatherForecastModel: Decodable, Equatable {
    let list: [DayForecastModel]
}

struct DayForecastModel: Decodable, Equatable {
    let dt: Int
    let main: DayForecastMainModel
    let weather: [DayForecastWeatherModel]
    let wind: DayForecastWindModel
    let rain: DayForecastRainModel?
}

struct DayForecastMainModel: Decodable, Equatable {
    let temp: Double
}

struct DayForecastWeatherModel: Decodable, Equatable {
    let main: String
    let icon: String
}

struct DayForecastWindModel: Decodable, Equatable {
    let speed: Double
}

struct DayForecastRainModel: Decodable, Equatable {
    let threeHours: Double

    enum CodingKeys: String, CodingKey, Equatable {
        case threeHours = "3h"
    }
}
