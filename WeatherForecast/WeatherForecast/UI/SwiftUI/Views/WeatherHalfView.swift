//
//  WeatherHalfView.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 14.04.2025.
//

import Foundation
import SwiftUI

struct WeatherInfo_Combine {
    let partOfDay: String
    let temperature: String
    let weatherCondition: String
    let windSpeed: String
    let rainMm: String
}

struct WeatherHalfView: View {
    @StateObject private var vm: WeatherHalfViewModel_Combine
    
    init(
        halfDayWeatherForecast: HalfDayWeatherForecast,
        partOfDay: String
    ) {
        _vm = StateObject(wrappedValue: WeatherHalfViewModel_Combine(inputState: (
            partOfDay: partOfDay,
            config: halfDayWeatherForecast
        )))
    }
    
    var body: some View {
        if let weatherInfo = vm.weatherInfo {
            VStack(spacing: 8) {
                Text(weatherInfo.partOfDay)
                    .font(.headline)

                Image(uiImage: vm.weatherImage?.uiImage ?? UIImage(systemName: "exclamationmark.triangle.fill")!)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .foregroundColor(.gray)

                Text(weatherInfo.temperature)
                    .font(.body)

                Text(weatherInfo.weatherCondition)
                    .font(.subheadline)

                HStack(spacing: 4) {
                    Image(systemName: "wind")
                        .foregroundColor(.pink)
                    Text(weatherInfo.windSpeed)
                }

                HStack(spacing: 4) {
                    Image(systemName: "drop.fill")
                        .foregroundColor(.pink)
                    Text(weatherInfo.rainMm)
                }
            }
            .frame(maxWidth: .infinity)
        } else {
            Spacer()
        }
    }
}
