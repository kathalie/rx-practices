//
//  WeatherInfoViewModel.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 15.04.2025.
//

import Foundation
import RxSwift
import RxRelay

struct WeatherInfo {
    let temperature: String
    let weatherCondition: String
    let windSpeed: String
    let rainMm: String
}

class WeatherInfoViewModel {
    private let disposeBag = DisposeBag()
    private let weatherService = OpenWeatherService()
    
    // MARK: Input
    let config = PublishRelay<HalfDayWeatherForecast>()
    
    // MARK: Output
    private let _weatherImage = PublishRelay<WeatherImageModel?>()
    private(set) lazy var weatherImage = self._weatherImage.asObservable()
    
    private let _weatherInfo = PublishRelay<WeatherInfo>()
    private(set) lazy var weatherInfo = self._weatherInfo.asObservable()
    
    init() {
        config
            .bind(onNext: { [weak self] config in
                guard let self else {return}
                
                let newWeatherInfo = WeatherInfo(
                    temperature: "\(config.temperature)°C",
                    weatherCondition: config.weatherCondition,
                    windSpeed: "\(config.windSpeed)m/s",
                    rainMm: "\(config.rainMm)mm"
                )
                
                self._weatherInfo.accept(newWeatherInfo)
                self.fetchIcon(with: config.iconId)
            })
            .disposed(by: disposeBag)
    }
    
    private func fetchIcon(with id: String) {
        weatherService.fetchWeatherImage(with: id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] image in
                    guard let self else {return}
                    
                    self._weatherImage.accept(image)
                },
                onFailure: {[weak self] error in
                    guard let self else {return}
                    
                    print(error)
                    
                    self._weatherImage.accept(nil)
                }
            )
            .disposed(by: disposeBag)
    }
}
