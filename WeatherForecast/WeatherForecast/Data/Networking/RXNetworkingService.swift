//
//  RXNetworkingService.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 25.03.2025.
//

import Foundation
import RxSwift

class RXNetworkingService: NetworkingServiceProtocol {
    func fetchData(on request: URLRequest) -> Single<Data> {
        return Single<Data>.create { single in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    single(.failure(error))
                    return
                }
                
                guard let data else {
                    single(.failure(NetworkingError.noData))
                    return
                }
                
                single(.success(data))
            }
            
            task.resume()
            return Disposables.create { task.cancel() }
        }
    }
}
