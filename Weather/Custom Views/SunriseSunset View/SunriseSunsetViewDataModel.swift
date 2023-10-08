//
//  SunriseSunsetStruct.swift
//  Weather
//
//  Created by Арсений Кухарев on 19.07.2023.
//

import Foundation

/**
 SunriseSunsetView принимает объект этой модели для инициализации.
 - Note: Под каждый api  делать отдельный инициализатор
 */
struct SunriseSunsetViewDataModel {
    let startTimeStamp: Int
    let endTimeStamp: Int
    
    
    /// Для сайта https://openweathermap.org
    init(openWeatherResponce responce: OpenWeatherResponce) {
        self.startTimeStamp = responce.sunriseSunset?.sunriseTime ?? 0
        self.endTimeStamp = responce.sunriseSunset?.sunsetTime ?? 0
    }
    
}
