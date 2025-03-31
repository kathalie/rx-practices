//
//  WeatherForecastViewModelTests.swift
//  WeatherForecastTests
//
//  Created by Kathryn Verkhogliad on 25.03.2025.
//

import XCTest
import RxSwift
import RxTest
import RxBlocking
@testable import WeatherForecast

final class WeatherForecastViewModelTests: XCTestCase {
    var scheduler: TestScheduler!
    var disposeBag: DisposeBag!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        scheduler = TestScheduler(initialClock: 0)
        disposeBag = DisposeBag()
    }
    
    // TODO read more about blocking
    func testValidCityInput() {
        let input = "Kyiv"
        let expectedOutput = input
        
        let vm = WeatherForecastViewModel(initialTextFieldState: "")
        
        vm.inputCity.accept(input)

        let results = vm.outputCity.toBlocking()

        XCTAssertEqual(try results.first(), expectedOutput)
    }


    
    func testWeatherForecastViewModel_EmptyInput() {
        let vm = WeatherForecastViewModel(initialTextFieldState: "")
        
        let observer = scheduler.createObserver(String.self)
        
        scheduler.scheduleAt(0) {
            vm.inputCity.accept("")
            vm.outputCity.bind(to: observer).disposed(by: self.disposeBag)
        }
        
        scheduler.start()
        
        XCTAssertEqual(observer.events.map { $0.value.element }, [""])
    }
    
    
    
    override func tearDownWithError() throws {
        scheduler.scheduleAt(1000, action: { [weak self] in
            self?.disposeBag = nil
        })
        
        scheduler = nil
    }
}
