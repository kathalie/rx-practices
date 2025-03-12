//
//  CoordinatesModel.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import Foundation

struct CoordinatesModel: Decodable {
    let name: String
    let lat: Double
    let lon: Double
}
