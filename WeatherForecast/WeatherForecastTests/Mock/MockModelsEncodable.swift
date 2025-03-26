//
//  MockModelsEncodable.swift
//  WeatherForecastTests
//
//  Created by Kathryn Verkhogliad on 25.03.2025.
//

import Foundation
@testable import WeatherForecast

extension CoordinatesModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(lat, forKey: .lat)
        try container.encode(lon, forKey: .lon)
    }

    enum CodingKeys: String, CodingKey {
        case name, lat, lon
    }
}

extension WeekWeatherForecastModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(list, forKey: .list)
    }
    
    enum CodingKeys: String, CodingKey {
        case list
    }
}

extension DayForecastModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(dt, forKey: .dt)
        try container.encode(main, forKey: .main)
        try container.encode(weather, forKey: .weather)
        try container.encode(wind, forKey: .wind)
        try container.encodeIfPresent(rain, forKey: .rain)
    }
    
    enum CodingKeys: String, CodingKey {
        case dt, main, weather, wind, rain
    }
}

extension DayForecastMainModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(temp, forKey: .temp)
    }
    
    enum CodingKeys: String, CodingKey {
        case temp
    }
}

extension DayForecastWeatherModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(main, forKey: .main)
        try container.encode(icon, forKey: .icon)
    }
    
    enum CodingKeys: String, CodingKey {
        case main, icon
    }
}

extension DayForecastWindModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(speed, forKey: .speed)
    }
    
    enum CodingKeys: String, CodingKey {
        case speed
    }
}

extension DayForecastRainModel: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(threeHours, forKey: .threeHours)
    }
}

