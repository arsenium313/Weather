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
 SunriseSunsetView принимает эту модель в своём инициализаторе.
 Под каждый api с данными делать отдельный инициализатор в модели
*/
struct SunriseSunsetViewDataModel: SunriseSunsetViewProtocol {
    var startTimeStamp: Int
    var endTimeStamp: Int
    
    init(openWeatherResponce responce: OpenWeatherResponce) {
        self.startTimeStamp = responce.sunriseSunset?.sunriseTime ?? 0
        self.endTimeStamp = responce.sunriseSunset?.sunsetTime ?? 0
    }
    
}
