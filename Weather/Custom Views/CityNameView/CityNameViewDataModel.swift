//
//  CityNameViewDataModel.swift
//  Weather
//
//  Created by Арсений Кухарев on 09.10.2023.
//

import Foundation

/**
 Посредник между JSON и View.
 AirQualityView принимает эту модель для инициализации.
 Если в JSON поле nil, вернет значение по умолчанию
 */
struct CityNameViewDataModel {
    let cityName: String
    
    /// Для сайта https://openweathermap.org
    init(openWeatherResponce responce: GeoResponce) {
        self.cityName = responce.nameOfLocation ?? "--"
    }
}
