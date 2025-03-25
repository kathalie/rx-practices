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

    func testExample() throws {
        
    }
    
    override func tearDownWithError() throws {
        scheduler.scheduleAt(1000, action: { [weak self] in
            self?.disposeBag = nil
        })
        
        scheduler = nil
    }
}
