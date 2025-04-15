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
                    
                    Observable.just("")
                        .bind(to: self._outputCity)
                        .disposed(by: disposeBag)
                    
                    Observable.just(nil)
                        .bind(to: self._weatherForecast)
                        .disposed(by: disposeBag)
                    
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
                    
                    Observable.just(coordinatesModel)
                        .map{$0.name}
                        .bind(to: self._outputCity)
                        .disposed(by: disposeBag)
                    
                    self.fetchWeatherForecast(
                        lat: coordinatesModel.lat,
                        lon: coordinatesModel.lon
                    )
                },
                onFailure: {[weak self] error in
                    guard let self else {return}
                    
                    print(error)
                    
                    Observable.just("")
                        .bind(to: self._outputCity)
                        .disposed(by: disposeBag)
                    
                    Observable.just(nil)
                        .bind(to: self._weatherForecast)
                        .disposed(by: disposeBag)
                    
                    Observable.just((title: "Error", message: "Failed to find a city"))
                        .bind(to: self._error)
                        .disposed(by: self.disposeBag)
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

                    Observable.just(forecast)
                        .bind(to: self._weatherForecast)
                        .disposed(by: self.disposeBag)
                },
                onFailure: {[weak self] error in
                    guard let self else {return}
                    
                    print(error)
                    
                    Observable.just(nil)
                        .bind(to: self._weatherForecast)
                        .disposed(by: self.disposeBag)
                    
                    Observable.just((title: "Error", message: "Failed to fetch forecast"))
                        .bind(to: self._error)
                        .disposed(by: self.disposeBag)
                }
            )
            .disposed(by: disposeBag)
    }
}
