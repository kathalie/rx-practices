//
//  ViewController.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import UIKit
import RxSwift
import RxDataSources

struct SectionOfCustomData {
    var header: String
    var items: [Item]
}
extension SectionOfCustomData: SectionModelType {
    typealias Item = DayWeatherForecast

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
        
        doRxCocoaSetup()
    }
    
    private func doRxCocoaSetup() {
        // MARK: Input
        cityTextField.rx.text
            .orEmpty
            .bind(to: vm.inputCity)
            .disposed(by: disposeBag)
        
        
        // MARK: Output
        vm.error
            .bind(onNext: { [weak self] (title, message) in
                self?.showAlert(title: title, message: message)
            })
            .disposed(by: disposeBag)
        
        vm.outputCity
            .bind(to: cityNameLabel.rx.text)
            .disposed(by: disposeBag)
        
        vm.weatherForecast
            .bind(onNext: { [weak self] forecast in
                self?.fillTable(with: forecast)
            })
            .disposed(by: disposeBag)
    }
    
    
    private func fillTable(with forecast: WeekWeatherForecastModel?) {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionOfCustomData>(
          configureCell: { dataSource, tableView, indexPath, item in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: Const.dayForecastCellReuseId,
                for: indexPath
            ) as! WeatherForecastTableViewCell
              
            cell.config(with: item)
              
            return cell
        })
        
        var sections: [SectionOfCustomData] = []
        
        if let forecast {
            sections = [SectionOfCustomData(
                header: "",
                items: WeekWeatherForecast(from: forecast).wetherForecast
            )]
        }

        forecastTableView.dataSource = nil
        forecastTableView.delegate = nil
            
        Observable.just(sections)
          .bind(to: forecastTableView.rx.items(dataSource: dataSource))
          .disposed(by: disposeBag)
    }
}

