//
//  MainInfoResponceStruct.swift
//  Weather
//
//  Created by Арсений Кухарев on 18.07.2023.
//

import Foundation

/// Посредник между JSON и View.
/// TemperatureView принимает эту модель для инициализации.
/// Если в JSON поле nil, вернет значение по умолчанию
struct TemperatureViewDataModel {
    
    let currentTemp: Int
    let minTemp: Int
    let maxTemp: Int
    let feelsLikeTemp: Int
    let windSpeed: Int
    let windDirection: Int
    let description: String
    
    /// Для сайта https://openweathermap.org
    init(openWeatherResponce responce: OpenWeatherResponce) {
        self.currentTemp = Int(responce.tempAndPressure?.temp?.rounded(.awayFromZero) ?? 0)
        self.minTemp = Int(responce.tempAndPressure?.tempMin?.rounded(.awayFromZero) ?? 0)
        self.maxTemp = Int(responce.tempAndPressure?.tempMax?.rounded(.awayFromZero) ?? 0)
        self.feelsLikeTemp = Int(responce.tempAndPressure?.feelsLike?.rounded(.awayFromZero) ?? 0)
        self.description = responce.weatherDescription?.first?.description ?? "--"
        self.windSpeed = Int(responce.wind?.speed?.rounded(.awayFromZero) ?? 0)
        self.windDirection = responce.wind?.directionInDegrees ?? 0
    }

}
