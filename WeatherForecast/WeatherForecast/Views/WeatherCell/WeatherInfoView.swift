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
    
    // MARK: Output
    private let _weatherImage = PublishRelay<UIImage?>()
    private(set) lazy var weatherImage = self._weatherImage.asObservable()
    
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
        // MARK: Output
        weatherImage
            .bind(to: iconImage.rx.image)
            .disposed(by: disposeBag)
    }
    
    public func config(with config: HalfDayWeatherForecast) {
        fetchIcon(with: config.iconId)
        
        let configObservable = Observable.just(config)

        configObservable
            .map {"\($0.temperature)°C"}
            .bind(to: self.temperatureLabel.rx.text)
            .disposed(by: disposeBag)
        configObservable
            .map(\.weatherCondition)
            .bind(to: self.weatherConditionLabel.rx.text)
            .disposed(by: disposeBag)
        configObservable
            .map {"\($0.windSpeed)m/s"}
            .bind(to: self.windSpeedLabel.rx.text)
            .disposed(by: disposeBag)
        configObservable
            .map {"\($0.rainMm)mm"}
            .bind(to: self.rainLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func fetchIcon(with id: String) {
        fetchWeatherImage(with: id)
            .observe(on: MainScheduler.instance)
            .subscribe(
                onSuccess: { [weak self] image in
                    guard let self else {return}
                    
                    Observable.just(image)
                        .bind(to: self._weatherImage)
                        .disposed(by: self.disposeBag)
                },
                onFailure: {[weak self] error in
                    guard let self else {return}
                    
                    print(error)
                    
                    Observable.just(nil)
                        .bind(to: self._weatherImage)
                        .disposed(by: self.disposeBag)
                }
            )
            .disposed(by: disposeBag)
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
