//
//  Networking.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import RxSwift
import UIKit

protocol WeatherServiceProtocol {
    func fetchCityCoordinatess(for cityName: String) -> Single<CoordinatesModel>
    func fetchWeekForecast(lat: Double, lon: Double) -> Single<WeekWeatherForecastModel>
    func fetchWeatherImage(with id: String) -> Single<UIImage>
}
