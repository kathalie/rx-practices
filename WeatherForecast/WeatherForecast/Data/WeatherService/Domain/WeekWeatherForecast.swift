//
//  WeatherInfoViewModel.swift
//  WeatherForecast
//
//  Created by Kathryn Verkhogliad on 17.03.2025.
//

import Foundation

struct WeekWeatherForecast {
    private(set) var weatherForecast: [DayWeatherForecast] = []
    
    init(from model: WeekWeatherForecastModel) {
        let transfromedModel = self.transformedModel(from: model)
        
        let grouppedModel = Dictionary(grouping: transfromedModel) { $0.date }
            .sorted(by: {$0.key < $1.key})
        grouppedModel.forEach { (date, forecastInfos) in
            guard
                let dayForecastInfo = forecastInfos.first(where: {(6...18).contains($0.hour)})?.forecast,
                let nightForecastInfo = forecastInfos.first(where: {(0...5).contains($0.hour) || (19...24).contains($0.hour)})?.forecast
            else {return}
            
            weatherForecast.append(DayWeatherForecast(
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
