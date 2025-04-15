//
//  WeatherInfoView.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import UIKit
import RxSwift
import RxRelay

class WeatherInfoView: UIView {
    private let disposeBag = DisposeBag()
    private let vm = WeatherInfoViewModel()
    
    let kCONTENT_XIB_NAME = "WeatherInfoView"
    
    @IBOutlet weak var dayForecastView: UIView!
    @IBOutlet weak var iconImage: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherConditionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var rainLabel: UILabel!
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed(kCONTENT_XIB_NAME, owner: self, options: nil)
        dayForecastView.fixInView(self)
        
        doRxCocoaSetup()
    }
    
    private func doRxCocoaSetup()  {
        vm.weatherImage
            .map { $0?.uiImage ?? UIImage(systemName: "exclamationmark.triangle.fill") }
            .bind(to: iconImage.rx.image)
            .disposed(by: disposeBag)
        
        vm.weatherInfo
            .map {$0.weatherCondition}
            .bind(to: self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        vm.weatherInfo
            .map {$0.temperature}
            .bind(to: self.weatherConditionLabel.rx.text)
            .disposed(by: disposeBag)
        vm.weatherInfo
            .map {$0.windSpeed}
            .bind(to: self.windSpeedLabel.rx.text)
            .disposed(by: disposeBag)
        vm.weatherInfo
            .map {$0.rainMm}
            .bind(to: self.rainLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    public func config(with config: HalfDayWeatherForecast) {
        vm.config.accept(config)
    }
}

extension UIView
{
    func fixInView(_ container: UIView!) -> Void{
        self.translatesAutoresizingMaskIntoConstraints = false;
        self.frame = container.frame;
        container.addSubview(self);
        NSLayoutConstraint(item: self, attribute: .leading, relatedBy: .equal, toItem: container, attribute: .leading, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .trailing, relatedBy: .equal, toItem: container, attribute: .trailing, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .top, relatedBy: .equal, toItem: container, attribute: .top, multiplier: 1.0, constant: 0).isActive = true
        NSLayoutConstraint(item: self, attribute: .bottom, relatedBy: .equal, toItem: container, attribute: .bottom, multiplier: 1.0, constant: 0).isActive = true
    }
}
