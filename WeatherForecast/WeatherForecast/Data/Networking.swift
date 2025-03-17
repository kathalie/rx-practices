//
//  Networking.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 12.03.2025.
//

import RxSwift
import UIKit

enum GeocodingError: String, Error {
    case failedToFetchCity = "Failed to fetch a city"
    case failedToParseCity = "Failed to parse a city"
}

enum ForecastError: String, Error {
    case failedToFetchForecast = "Failed to fetch a week forecast"
    case failedToParseForecast = "Failed to parse a week forecast"
}

enum WeatherIconError: String, Error {
    case failedToFetchIcon = "Failed to fetch a weather icon"
    case failedToParseIcon = "Failed to parse a weather icon"
}

func fetchCityCoordinatess(for cityName: String) -> Single<CoordinatesModel> {
    let openWeatherGeoApi = "https://api.openweathermap.org/geo/1.0/direct"
    
    return Single<CoordinatesModel>.create { single in
        let url = URL(string: openWeatherGeoApi)!
            .appending(queryItems: [
                URLQueryItem(name: "q", value: cityName),
                URLQueryItem(name: "limit", value: "1"),
                URLQueryItem(name: "appid", value: apiKey),
            ])
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                single(.failure(GeocodingError.failedToFetchCity)); return
            }
            
            guard let data else {
                single(.failure(GeocodingError.failedToFetchCity)); return
            }
            
            do {
//                print(String(data: data, encoding: .utf8) ?? "")
                
                let decodedData = try JSONDecoder().decode(Array<CoordinatesModel>.self, from: data)
                
                guard let decodedCoordinates = decodedData.first else {
                    single(.failure(GeocodingError.failedToParseCity)); return
                }
                
                single(.success(decodedCoordinates))
            } catch {
                single(.failure(GeocodingError.failedToParseCity)); return
            }
        }
        
        task.resume()
        
        return Disposables.create { task.cancel() }
    }
}

func fetchWeekForecast(lat: Double, lon: Double) -> Single<WeekWeatherForecastModel> {
    let openWeatherForecastApi = "https://api.openweathermap.org/data/2.5/forecast"
    
    return Single<WeekWeatherForecastModel>.create { single in
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
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                single(.failure(ForecastError.failedToFetchForecast)); return
            }
            
            guard let data else {
                single(.failure(ForecastError.failedToFetchForecast)); return
            }
            
            do {
//                print(String(data: data, encoding: .utf8) ?? "")
                
                let decodedData = try JSONDecoder().decode(WeekWeatherForecastModel.self, from: data)
                
                single(.success(decodedData))
            } catch {
                single(.failure(ForecastError.failedToParseForecast)); return
            }
        }
        
        task.resume()
        
        return Disposables.create { task.cancel() }
    }
}

func fetchWeatherImage(with id: String) -> Single<UIImage> {
    return Single<UIImage>.create { single in
        let url = URL(string: "https://openweathermap.org/img/wn/")!
            .appending(path: "\(id).png")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("image/jpeg", forHTTPHeaderField: "Content-Type")
        
        let task = URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                print(error)
                single(.failure(WeatherIconError.failedToFetchIcon)); return
            }
            
            guard let data else {
                single(.failure(WeatherIconError.failedToFetchIcon)); return
            }
            
            guard let image = UIImage(data: data) else {
                single(.failure(WeatherIconError.failedToParseIcon)); return
            }
            
            single(.success(image))
        }
        
        task.resume()
        
        return Disposables.create { task.cancel() }
    }
}
