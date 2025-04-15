//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import RxSwift
import RxRelay

class WeatherForecastViewModel {
    private let disposeBag = DisposeBag()
    private let weatherService = OpenWeatherService()
    
    // MARK: Input
    let inputCity = PublishRelay<String>()
    
    // MARK: Output
    private let _weatherForecast = PublishRelay<WeekWeatherForecastModel?>()
    private(set) lazy var weatherForecast = self._weatherForecast.asObservable()
    
    private let _error = PublishRelay<(title: String, message: String)>()
    private(set) lazy var error = self._error
    
    private let _outputCity = PublishRelay<String>()
    private(set) lazy var outputCity = self._outputCity
    
    // MARK: Init
    init(initialTextFieldState: String) {
        inputCity
            .distinctUntilChanged()
            .bind(onNext: { [weak self] city in
                guard !city.isEmpty else {
                    guard let self else {return}
                    
                    self._outputCity.accept("")
                    self._weatherForecast.accept(nil)
                    
                    return
                }
                
                self?.fetchWeatherForecast(for: city)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Fetch
    private func fetchWeatherForecast(for cityName: String) {
        weatherService.fetchCityCoordinatess(for: cityName)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: {[weak self] coordinatesModel in
                    guard let self else {return}
                    
                    self._outputCity.accept(coordinatesModel.name)
                    self.fetchWeatherForecast(
                        lat: coordinatesModel.lat,
                        lon: coordinatesModel.lon
                    )
                },
                onFailure: {[weak self] error in
                    guard let self else {return}
                    
                    print(error)
                    
                    self._outputCity.accept("")
                    self._weatherForecast.accept(nil)
                    self._error.accept((
                        title: "Error",
                        message: "Failed to find a city"
                    ))
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func fetchWeatherForecast(lat: Double, lon: Double) {
        weatherService.fetchWeekForecast(lat: lat, lon: lon)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: {[weak self] forecast in
                    guard let self else {return}
                    
                    self._weatherForecast.accept(forecast)
                },
                onFailure: {[weak self] error in
                    guard let self else {return}
                    
                    print(error)
                    
                    self._weatherForecast.accept(nil)
                    self._error.accept((
                        title: "Error",
                        message: "Failed to fetch forecast"
                    ))
                }
            )
            .disposed(by: disposeBag)
    }
}
