//
//  File.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 15.04.2025.
//

import Foundation
import Combine

struct WeatherDayInfo {
    let forecastDate: String
    let dayForecast: HalfDayWeatherForecast
    let nightForecast: HalfDayWeatherForecast
}

class WeatherDayViewModel_Combine: ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Input
    @Published private var config: DayWeatherForecast?
    
    // MARK: Output
    @Published private(set) var weatherDayInfo: WeatherDayInfo?
    
    init(config: DayWeatherForecast) {
        self.config = config
        setupCombine()
    }
    
    private func setupCombine() {
        $config
            .map {
                guard let config = $0 else {return nil}
                                
                return WeatherDayInfo(
                    forecastDate: config.date ,
                    dayForecast: config.dayForecast,
                    nightForecast: config.nightForecast)
            }
            .assign(to: \.weatherDayInfo, on: self)
            .store(in: &cancellable)
    }
}
