//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import UIKit
import RxSwift
import RxDataSources

struct WeatherInfo {
    let date: Int
    let iconImage: UIImage
    let temperature: Double
    let weatherCondition: String
    let windSpeed: Double
    let rainMm: Double
}

struct SectionOfCustomData {
    var header: String
  var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
  typealias Item = WeatherInfo

   init(original: SectionOfCustomData, items: [Item]) {
    self = original
    self.items = items
  }
}

class ViewController: UIViewController {
    struct Const {
        static let dayForecastCellReuseId = "day_forecast_cell"
    }
    
    private let disposeBag = DisposeBag()
    private var vm: WeatherForecastViewModel!
    
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var forecastTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vm = WeatherForecastViewModel(initialTextFieldState: cityTextField.text ?? "")
        
        fillTableWithData()
//        fetchWeatherForecast(for: "London")
    }
    
    private func fillTableWithData() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
          configureCell: { dataSource, tableView, indexPath, item in
              let cell = tableView.dequeueReusableCell(withIdentifier: Const.dayForecastCellReuseId, for: indexPath) as! WeatherForecastTableViewCell
            cell.config(with: item)
              
            return cell
        })
        
        let sections = [
            SectionOfCustomData(header: "First section", items: [WeatherInfo(date: 123, iconImage: UIImage(systemName: "multiply.circle.fill")!, temperature: 12.4, weatherCondition: "Rain", windSpeed: 12.3, rainMm: 12.3)])
        ]

        Observable.just(sections)
          .bind(to: forecastTableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
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
//                    self?.icon.image = image
                },
                onFailure: {[weak self] error in
                    print(error)
                    
                    self?.showAlert(title: "Error", message: "Failed to fetch icon")
                }
            )
            .disposed(by: disposeBag)
    }
}

