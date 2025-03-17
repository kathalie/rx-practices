//
//  WeatherInfoViewModel.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 17.03.2025.
//

import Foundation
import RxSwift

struct WeekWeatherForecast {
    private(set) var wetherForecast: [DayWeatherForecast] = []
    
    init(from model: WeekWeatherForecastModel) {
        let transfromedModel = self.transformedModel(from: model)
        
        let grouppedModel = Dictionary(grouping: transfromedModel) { $0.date }
            .sorted(by: {$0.key < $1.key})
        
        print(grouppedModel)
        
        grouppedModel.forEach { (date, forecastInfos) in
            guard
                let dayForecastInfo = forecastInfos.first(where: {$0.hour == 13})?.forecast,
                let nightForecastInfo = forecastInfos.first(where: {$0.hour == 22})?.forecast
            else {return}
            
            wetherForecast.append(DayWeatherForecast(
                date: date,
                dayForecast: dayForecastInfo,
                nightForecast: nightForecastInfo
            ))
        }
    }
    
    private func transformedModel(from model: WeekWeatherForecastModel) -> [(date: String, hour: Int, forecast: HalfDayWeatherForecast)] {
        return model.list.compactMap { dayForecast in
            let date = Date(timeIntervalSince1970: TimeInterval(dayForecast.dt))
            
            let calendar = Calendar.current
            let hour = calendar.component(.hour, from: date)
            
            let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
            let dateString = formatter.string(from: date)
            
            guard let forecast = HalfDayWeatherForecast.init(from: dayForecast)
            else {return nil}
            
            return (
                date: dateString,
                hour: hour,
                forecast: forecast
            )
        }
    }
}

struct DayWeatherForecast {
    let date: String
    let dayForecast: HalfDayWeatherForecast
    let nightForecast: HalfDayWeatherForecast
}

struct HalfDayWeatherForecast {
    let iconId: String
    let temperature: Double
    let weatherCondition: String
    let windSpeed: Double
    let rainMm: Double
    
    init?(from model: DayForecastModel){
        guard
            let iconId = model.weather.first?.icon,
            let weatherCondition = model.weather.first?.main
        else { return nil }
            
        self.iconId = iconId
        self.temperature = model.main.temp
        self.weatherCondition = weatherCondition
        self.windSpeed = model.wind.speed
        self.rainMm = model.rain?.threeHours ?? 0
    }
}
