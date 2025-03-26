//
//  WeatherForecastTests.swift
//  WeatherForecastTests
//
//  Created by Kathryn Verkhogliad on 25.03.2025.
//

import XCTest
import RxSwift
import RxTest
@testable import WeatherForecast

final class WeatherForecastDecoderTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    func testFetchCityCoordinatesSuccess() {
        let expectedModel = CoordinatesModel(name: "Kyiv", lat: 40.0, lon: 40.0)
        let ignoredData = CoordinatesModel(name: "Berlin", lat: 30.0, lon: 10.0)
        
        let mockData = try! JSONEncoder().encode([expectedModel, ignoredData])
        let mockService = MockNetworkingService(response: .just(mockData))
        let weatherService = OpenWeatherService(networkingService: mockService)
                
        let fetchedCoordinates = weatherService.fetchCityCoordinatess(for: expectedModel.name)
            
        let observer = scheduler.createObserver(CoordinatesModel.self)

        scheduler.scheduleAt(0) {
            fetchedCoordinates
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        let results = observer.events.compactMap {$0.value.element}
        
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.name, expectedModel.name)
    }
    
    func testFetchCityCoordinatesFailure() {
        let mockService = MockNetworkingService(response: .error(DecodingError.failedToDecode))
        let weatherService = OpenWeatherService(networkingService: mockService)
        
        let observer = scheduler.createObserver(CoordinatesModel.self)
        
        scheduler.scheduleAt(0) {
            weatherService.fetchCityCoordinatess(for: "")
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        let results = observer.events.compactMap {$0.value}
        
        XCTAssertEqual(results.count, 1)
        XCTAssertTrue(results.first?.error is DecodingError)
    }
    
    func testFetchWeekForecastSuccess() {
        let expectedModel = WeekWeatherForecastModel(list: [
            DayForecastModel(
                dt: 1700000000,
                main: DayForecastMainModel(temp: 22.5),
                weather: [DayForecastWeatherModel(main: "Clear", icon: "01d")],
                wind: DayForecastWindModel(speed: 5.0),
                rain: DayForecastRainModel(threeHours: 0.0)
            )
        ])
        let mockData = try! JSONEncoder().encode(expectedModel)
        let mockService = MockNetworkingService(response: .just(mockData))
        let weatherService = OpenWeatherService(networkingService: mockService)
        
        let observer = scheduler.createObserver(WeekWeatherForecastModel.self)
        
        scheduler.scheduleAt(0) {
            weatherService.fetchWeekForecast(lat: 30.0, lon: 30.0)
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        let results = observer.events.compactMap {$0.value.element}
                
        XCTAssertEqual(results.count, 1)
        XCTAssertEqual(results.first?.list.count, 1)
        XCTAssertEqual(results.first?.list.first?.weather.first?.main, "Clear")
    }
        
    func testFetchWeekForecastFailure() {
        let mockService = MockNetworkingService(response: .error(DecodingError.failedToDecode))
        let weatherService = OpenWeatherService(networkingService: mockService)
        
        let observer = scheduler.createObserver(WeekWeatherForecastModel.self)
        
        scheduler.scheduleAt(0) {
            weatherService.fetchWeekForecast(lat: 0, lon: 0)
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        let results = observer.events.compactMap {$0.value}
        
        XCTAssertEqual(results.count, 1)
        XCTAssertTrue(results.first?.error is DecodingError)
    }
    
    func testFetchWeatherImageSuccess() {
        let expectedImage = UIImage(systemName: "cloud.sun.fill")!
        let mockService = MockNetworkingService(response: .just(expectedImage.pngData()!))
        let weatherService = OpenWeatherService(networkingService: mockService)
        
        let observer = scheduler.createObserver(UIImage.self)
        
        scheduler.scheduleAt(0) {
            weatherService.fetchWeatherImage(with: "cloudSunIconId")
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        let results = observer.events.compactMap {$0.value.element}
        
        XCTAssertEqual(results.count, 1)
    }
    
    func testFetchWeatherImageFailure() {
        let mockService = MockNetworkingService(response: .error(DecodingError.failedToDecode))
        let weatherService = OpenWeatherService(networkingService: mockService)
        
        let observer = scheduler.createObserver(UIImage.self)
        
        scheduler.scheduleAt(0) {
            weatherService.fetchWeatherImage(with: "invalidId")
                .asObservable()
                .subscribe(observer)
                .disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        let results = observer.events.compactMap {$0.value}
        
        XCTAssertEqual(results.count, 1)
        XCTAssertTrue(results.first?.error is DecodingError)
    }
    
    override func tearDownWithError() throws {
        scheduler.scheduleAt(1000, action: { [weak self] in
            self?.disposeBag = nil
        })
        
        scheduler = nil
    }
}
