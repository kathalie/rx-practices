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

final class WeatherForecastTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }

    func testFetchCityCoordinates_Success() {
//        let expectedCity = CoordinatesModel(lat: 50.45, lon: 30.52)
//        let mockService = MockWeatherService(expectedCoordinates: expectedCity)
//        
//        let result = try? mockService.fetchCityCoordinatess(for: "Kyiv").toBlocking().first()
//        
//        XCTAssertEqual(result?.lat, expectedCity.lat)
//        XCTAssertEqual(result?.lon, expectedCity.lon)
    }
    
    override func tearDownWithError() throws {
        scheduler.scheduleAt(1000, action: { [weak self] in
            self?.disposeBag = nil
        })
        
        scheduler = nil
    }
}
