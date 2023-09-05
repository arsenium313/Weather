//
//  AirQualityViewDataModel.swift
//  Weather
//
//  Created by Арсений Кухарев on 20.07.2023.
//

import Foundation

/// Список обязательных свойст для создания AirQualityView
protocol AirQualityViewProtocol {
    var index: Int { get }
}


/**
 AirQualityView принимает объект этой модели для инициализации.
 - Note: Под каждый api  делать отдельный инициализатор
*/
struct AirQualityViewDataModel: AirQualityViewProtocol {
    let index: Int
    
    /**
     Для сайта https://openweathermap.org
     */
    init(openWeatherResponce responce: OpenWeatherAirPollutionResponce) {
        self.index = responce.list?.first?.main?.aqi ?? 0
    }
}
