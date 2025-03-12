//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    private let disposeBag = DisposeBag()
    private let vm = WeatherForecastViewModel()

    @IBOutlet weak var icon: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeatherForecast(for: "London")
    }

    private func fetchWeatherForecast(for cityName: String) {
        fetchCityCoordinatess(for: cityName)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: {[weak self] coordinatesModel in
                    print("Parsed coords: \(coordinatesModel.lat), \(coordinatesModel.lon)")
                    
                    self?.fetchWeatherForecast(lat: coordinatesModel.lat, lon: coordinatesModel.lon)
                },
                onFailure: {[weak self] error in
                    print(error)
                    
                    self?.showAlert(title: "Error", message: "Failed to fetch coordinates")
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func fetchWeatherForecast(lat: Double, lon: Double) {
        fetchWeekForecast(lat: lat, lon: lon)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: {[weak self] forecast in
                    print(forecast)
                    
                    self?.fetchIcon(with: forecast.list.first?.weather.first?.icon ?? "")
                },
                onFailure: {[weak self] error in
                    print(error)
                    
                    self?.showAlert(title: "Error", message: "Failed to fetch forecast")
                }
            )
            .disposed(by: disposeBag)
    }
    
    private func fetchIcon(with id: String) {
        fetchWeatherImage(with: id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] image in
                    self?.icon.image = image
                },
                onFailure: {[weak self] error in
                    print(error)
                    
                    self?.showAlert(title: "Error", message: "Failed to fetch icon")
                }
            )
            .disposed(by: disposeBag)
    }
}

