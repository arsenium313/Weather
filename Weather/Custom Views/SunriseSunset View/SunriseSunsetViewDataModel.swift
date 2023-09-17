//
//  SunriseSunsetStruct.swift
//  Weather
//
//  Created by Арсений Кухарев on 19.07.2023.
//

import Foundation

/// Список обязательных свойст для создания SunriseSunsetView
protocol SunriseSunsetViewProtocol {
    var startTimeStamp: Int { get }
    var endTimeStamp: Int { get }
}


/**
 SunriseSunsetView принимает объект этой модели для инициализации.
 - Note: Под каждый api  делать отдельный инициализатор
 */
struct SunriseSunsetViewDataModel: SunriseSunsetViewProtocol {
    let startTimeStamp: Int
    let endTimeStamp: Int
    
    
    /// Для сайта https://openweathermap.org
    init(openWeatherResponce responce: OpenWeatherResponce) {
        self.startTimeStamp = responce.sunriseSunset?.sunriseTime ?? 0
        self.endTimeStamp = responce.sunriseSunset?.sunsetTime ?? 0
    }
    
}
