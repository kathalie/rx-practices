//
//  MockNetworkingService.swift
//  WeatherForecastTests
//
//  Created by Kathryn Verkhogliad on 25.03.2025.
//

import Foundation
import RxSwift
@testable import WeatherForecast

class MockNetworkingService: NetworkingServiceProtocol {
    var response: Single<Data>
    
    init(response: Single<Data>) {
        self.response = response
    }
    
    func fetchData(on request: URLRequest) -> Single<Data> {
        return response
    }
}
