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
    
    func testValidCityAsDefault() {
        let inputCity = "Kyiv"
        let vm = WeatherForecastViewModel(initialTextFieldState: inputCity)
        
        vm.inputCity.accept(inputCity)
        
        let outputCityResults = vm.outputCity.toBlocking()
        let weatherForecastResults = vm.weatherForecast.toBlocking()
        
        XCTAssertEqual(try outputCityResults.first(), inputCity)
        XCTAssertNotNil(try weatherForecastResults.first())
    }
    
    func testValidCityInput() {
        let input = "Kyiv"
        let expectedOutput = input
        
        let vm = WeatherForecastViewModel(initialTextFieldState: "")
        
        vm.inputCity.accept(input)

        let results = vm.outputCity.toBlocking()

        XCTAssertEqual(try results.first(), expectedOutput)
    }
    
    func testPastedCityInputWithWhitespace() {
        let input = "   Kyiv   "
        let expectedOutput = "Kyiv"
        
        let vm = WeatherForecastViewModel(initialTextFieldState: "")
        
        vm.inputCity.accept(input)
        
        let results = vm.outputCity.toBlocking()
        
        XCTAssertEqual(try results.first(), expectedOutput)
    }
    
    
    override func tearDownWithError() throws {
        scheduler.scheduleAt(1000, action: { [weak self] in
            self?.disposeBag = nil
        })
        
        scheduler = nil
    }
}
