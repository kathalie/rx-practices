//
//  WeatherHalfViewModel.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 14.04.2025.
//

import Foundation
import Combine
import RxCombine

class WeatherHalfViewModel_Combine: ObservableObject {
    typealias InputState = (
        partOfDay: String,
        config: HalfDayWeatherForecast
    )
    
    private var cancellable = Set<AnyCancellable>()
    
    // MARK: Input
    @Published private var inputState: InputState
    
    // MARK: Output
    @Published private(set) var weatherImage: WeatherImageModel?
    @Published private(set) var weatherInfo: WeatherInfo_Combine?
    
    init(inputState: InputState) {
        self.inputState = inputState
        setupCombine()
    }
    
    private func setupCombine() {
        $inputState
            .map { [weak self] inputState in
                guard let self
                else {return nil}
                
                let (partOfDay, config) = inputState
                
                self.fetchIcon(with: config.iconId)
                
                return WeatherInfo_Combine(
                    partOfDay: partOfDay,
                    temperature: "\(config.temperature)°C",
                    weatherCondition: config.weatherCondition,
                    windSpeed: "\(config.windSpeed)m/s",
                    rainMm: "\(config.rainMm)mm"
                )
            }
            .assign(to: \.weatherInfo, on: self)
            .store(in: &cancellable)
    }
    
    private func fetchIcon(with id: String) {
        weatherService.fetchWeatherImage(with: id)
            .asPublisher()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    guard
                        let self,
                        case .failure(let error) = completion
                    else {return}
                
                    print(error.localizedDescription)
                    
                    self.weatherImage = nil
                },
                receiveValue: {
                    [weak self] image in
                    guard let self else {return}
                    
                    self.weatherImage = image
                }
            )
            .store(in: &cancellable)
    }
}
