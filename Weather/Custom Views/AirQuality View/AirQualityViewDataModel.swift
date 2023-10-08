//
//  AirQualityViewDataModel.swift
//  Weather
//
//  Created by Арсений Кухарев on 20.07.2023.
//

import Foundation

/**
 Посредник между JSON и View.
 AirQualityView принимает эту модель для инициализации.
 Если в JSON поле nil, вернет значение по умолчанию
 */
struct AirQualityViewDataModel {
    let index: Int
    
    /// Для сайта https://openweathermap.org
    init(openWeatherResponce responce: OpenWeatherAirPollutionResponce) {
        self.index = responce.list?.first?.main?.aqi ?? 0
    }
}
