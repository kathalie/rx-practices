//
//  WeatherForecastViewModel.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import RxSwift
import RxRelay

class WeatherForecastViewModel {
    let textFieldState: BehaviorRelay<String>
    
    init(initialTextFieldState: String) {
        textFieldState = BehaviorRelay<String>(value: initialTextFieldState)
    }
}
