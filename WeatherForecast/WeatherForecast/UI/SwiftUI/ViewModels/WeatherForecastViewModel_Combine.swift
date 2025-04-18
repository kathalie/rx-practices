//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 14.04.2025.
//

import Foundation
import Combine
import RxCombine

class WeatherForecastViewModel_Combine: ObservableObject {
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Input
    @Published var inputCity: String
    
    // MARK: Output
    @Published private(set) var weatherForecast: WeekWeatherForecast?
    @Published private(set) var error: (title: String, message: String)?
    @Published private(set) var outputCity: String = ""
    
    // MARK: Init
    init(initialTextFieldState: String) {
        self.inputCity = initialTextFieldState
        
        setupInputCityState()
    }
    
    private func setupInputCityState() {
        $inputCity
            .debounce(
                for: .seconds(1),
                scheduler: DispatchQueue.main
            )
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] city in
                guard let self else {return}
                
                guard !city.isEmpty else {
                    self.outputCity = ""
                    self.weatherForecast = nil
                    
                    return
                }
                
                self.fetchWeatherForecast(for: city)
            })
            .store(in: &cancellable)
    }
    
    // MARK: Fetch
    private func fetchWeatherForecast(for cityName: String) {
        weatherService.fetchCityCoordinatess(for: cityName)
            .asPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard
                        let self,
                        case .failure(let error) = completion
                    else {return}
                    
                    print(error.localizedDescription)
                    
                    self.outputCity = ""
                    self.weatherForecast = nil
                    self.error = (
                        title: "Error",
                        message: "Failed to find a city"
                    )
                    
                },
                receiveValue: { [weak self] coordinatesModel in
                    guard let self else {return}
                    
                    self.outputCity = coordinatesModel.name
                    self.fetchWeatherForecast(
                        lat: coordinatesModel.lat,
                        lon: coordinatesModel.lon
                    )
                }
            )
            .store(in: &cancellable)
    }
    
    private func fetchWeatherForecast(lat: Double, lon: Double) {
        weatherService.fetchWeekForecast(lat: lat, lon: lon)
            .asPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard
                        let self,
                        case .failure(let error) = completion
                    else {return}
                    
                    print(error.localizedDescription)
                    
                    self.weatherForecast = nil
                    self.error = (
                        title: "Error",
                        message: "Failed to fetch forecast"
                    )
                },
                receiveValue: {[weak self] forecast in
                    guard let self else {return}
                    
                    self.weatherForecast = WeekWeatherForecast(from: forecast)
                }
            )
            .store(in: &cancellable)
    }
}
