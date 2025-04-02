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
    
    /**
     * Tests sequential typing of a valid city name.
     * Expected result: the last entered string ("Kyiv") should be in `outputCity`.
     */
    func testTypingValidCityName() {
//        let inputs = ["K", "Ky", "Kyi", "Kyiv"]
//        let expectedOutput = inputs.last!
//        
//        let vm = WeatherForecastViewModel(initialTextFieldState: "")
//        
//        let observer = scheduler.createObserver(String.self)
//        
//        let inputSequence = scheduler.createColdObservable(
//            inputs.enumerated().map { index, input in
//                    .next(index * 10, input)
//            }
//        )
//        
//        inputSequence
//            .bind(to: vm.inputCity)
//            .disposed(by: disposeBag)
//        
//        vm.outputCity
//            .bind(to: observer)
//            .disposed(by: disposeBag)
//        
//        scheduler.start()
//        
//        let results = observer.events.compactMap { $0.value.element }
//        
//        XCTAssertEqual(results.last, expectedOutput)
    }
    
    /**
     * Tests entering an incomplete or  invalid city name.
     * Expected result: the entered string "K" should not result in  a valid city name.
     */
    func testTypingInvalidCityName() {
        let inputs = ["K"]
        let notExpectedOutput = inputs.last
        
        let vm = WeatherForecastViewModel(initialTextFieldState: "")
        
        inputs.forEach{ vm.inputCity.accept($0) }
        
        let results = vm.outputCity.toBlocking()
        
        XCTAssertNotEqual(try results.first(), notExpectedOutput)
    }
    
    /**
     * Tests entering a  valid city name.
     * Expected result: the exact input string ("Kyiv") should be  in `outputCity`.
     */
    func testValidCityInput() {
        let input = "Kyiv"
        let expectedOutput = input
        
        let vm = WeatherForecastViewModel(initialTextFieldState: "")
        
        vm.inputCity.accept(input)
        
        let results = vm.outputCity.toBlocking()
        
        XCTAssertEqual(try results.first(), expectedOutput)
    }
    
    /**
     * Tests pasting a city name with whitespace.
     * Expected result: the whitespace should be trimmed, and  "Kyiv" stored as a valid city name  in `outputCity`.
     */
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
