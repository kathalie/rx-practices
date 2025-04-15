//
//  OpenWeatherService.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 25.03.2025.
//

import Foundation
import RxSwift

class OpenWeatherService: WeatherServiceProtocol {
    private let decodingService: DecodingServiceProtocol
    private let networkingService: NetworkingServiceProtocol
    
    init(
        decodingService: DecodingServiceProtocol = JSONDecodingService(),
        networkingService: NetworkingServiceProtocol = RXNetworkingService()
    ) {
        self.decodingService = decodingService
        self.networkingService = networkingService
    }
    
    func fetchCityCoordinatess(for cityName: String) -> Single<CoordinatesModel> {
        let openWeatherGeoApi = "https://api.openweathermap.org/geo/1.0/direct"
        
        let url = URL(string: openWeatherGeoApi)!
            .appending(queryItems: [
                URLQueryItem(name: "q", value: cityName),
                URLQueryItem(name: "limit", value: "1"),
                URLQueryItem(name: "appid", value: apiKey),
            ])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let fetchedData = networkingService.fetchData(on: request)
        
        return fetchedData
            .map { data in
                let decodedCoordinates = self.decodingService.decode([CoordinatesModel].self, from: data)
                
                guard let firstCoordinate = try? decodedCoordinates.get().first
                else { throw DecodingError.failedToDecode }
                
                return firstCoordinate
            }
    }

    func fetchWeekForecast(lat: Double, lon: Double) -> Single<WeekWeatherForecastModel> {
        let openWeatherForecastApi = "https://api.openweathermap.org/data/2.5/forecast"
        
        let url = URL(string: openWeatherForecastApi)!
            .appending(queryItems: [
                URLQueryItem(name: "lat", value: "\(lat)"),
                URLQueryItem(name: "lon", value: "\(lon)"),
                URLQueryItem(name: "units", value: "metric"),
                URLQueryItem(name: "appid", value: apiKey),
            ])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let fetchedData = networkingService.fetchData(on: request)
        
        return fetchedData
            .map { data in
                try self.decodingService.decode(WeekWeatherForecastModel.self, from: data).get()
            }
    }

    func fetchWeatherImage(with id: String) -> Single<WeatherImageModel> {
        let openWeatherIconApi = "https://openweathermap.org/img/wn/"
        
        let url = URL(string: openWeatherIconApi)!
            .appending(path: "\(id).png")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let fetchedImage = networkingService.fetchData(on: request)
        
        return fetchedImage
            .map { WeatherImageModel(imageData: $0) }
    }
}
