//
//  MainInfoResponceStruct.swift
//  Weather
//
//  Created by Арсений Кухарев on 18.07.2023.
//

import Foundation

/// Список обязательных свойст для создания TemperatureView
protocol TemperatureViewProtocol {
    var currentTemp: Int { get }
    var minTemp: Int { get }
    var maxTemp: Int { get }
    var feelsLikeTemp: Int { get }
    var windSpeed: Int { get }
    var windDirection: Int { get }
    var description: String { get }
}


/**
 TemperatureView принимает объект этой модели для инициализации.
 - Note: Под каждый api  делать отдельный инициализатор
*/
struct TemperatureViewDataModel: TemperatureViewProtocol {
    let currentTemp: Int
    let minTemp: Int
    let maxTemp: Int
    let feelsLikeTemp: Int
    let windSpeed: Int
    let windDirection: Int
    let description: String
    
    /**
     Для сайта https://openweathermap.org
     */
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
