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
 AirQualityView принимает эту модель в своём инициализаторе.
 Под каждый api с данными делать отдельный инициализатор
*/
struct AirQualityViewDataModel: AirQualityViewProtocol {
    let index: Int

    init(openWeatherResponce responce: OpenWeatherAirPollutionResponce) {
        self.index = responce.list?.first?.main?.aqi ?? 0
    }
}
