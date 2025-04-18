//
//  WeatherDayView.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 15.04.2025.
//

import Foundation
import SwiftUI

struct WeatherDayView: View {
    @StateObject private var vm: WeatherDayViewModel_Combine
    
    init(
        dayWeatherForecast: DayWeatherForecast
    ) {
        _vm = StateObject(wrappedValue: WeatherDayViewModel_Combine(config: dayWeatherForecast))
    }

    var body: some View {
        if let weatherDayInfo = vm.weatherDayInfo {
            VStack(spacing: 16) {
                Text(weatherDayInfo.forecastDate)
                    .font(.title3)
                    .foregroundColor(.pink)

                HStack {
                    WeatherHalfView(
                        halfDayWeatherForecast: weatherDayInfo.dayForecast,
                        partOfDay: "Day"
                    )
                    WeatherHalfView(
                        halfDayWeatherForecast: weatherDayInfo.nightForecast,
                        partOfDay: "Night"
                    )
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        } else {
            Spacer()
        }
    }
}
