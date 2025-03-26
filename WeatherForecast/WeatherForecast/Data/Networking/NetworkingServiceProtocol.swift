//
//  NetworkingService.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 25.03.2025.
//

import Foundation
import RxSwift

enum NetworkingError: Error {
    case noData
}

protocol NetworkingServiceProtocol {
    func fetchData(on request: URLRequest) -> Single<Data>
}

