//
//  Models.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import Foundation

struct WeekForecastModel: Decodable {
    let list: [DayForecast]
}

struct DayForecast: Decodable {
    let dt: Int
    let main: DayForecastMain
    let weather: [DayForecastWeather]
    let wind: DayForecastWind
    let rain: DayForecastRain?
}

struct DayForecastMain: Decodable {
    let temp: Double
}

struct DayForecastWeather: Decodable {
    let main: String
    let icon: String
}

struct DayForecastWind: Decodable {
    let speed: Double
}

struct DayForecastRain: Decodable {
    let threeHours: Double

    enum CodingKeys: String, CodingKey {
        case threeHours = "3h"
    }
}
