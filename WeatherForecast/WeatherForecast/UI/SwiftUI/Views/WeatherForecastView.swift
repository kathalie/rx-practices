//
//  WeatherForecastView.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 14.04.2025.
//

import Foundation
import SwiftUI

struct WeatherForecastView: View {
    @StateObject private var vm = WeatherForecastViewModel_Combine(initialTextFieldState: "")
    
    var body: some View {
        return VStack(spacing: 16) {
            TextField("Search...", text: $vm.inputCity)
                .padding()
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.horizontal)
            Text(vm.outputCity)
                .font(.title)
                .padding(.bottom, 8)
            
            if let weatherForecast = vm.weatherForecast {
                ScrollView {
                    LazyVStack {
                        ForEach(
                            weatherForecast.weatherForecast,
                            id: \.self
                        ) {
                            WeatherDayView(dayWeatherForecast: $0)
                            Divider()
                        }
                    }
                }
            } else {
                Spacer()
            }
        }
        .padding(.top)
    }
}

#Preview {
    WeatherForecastView()
}
