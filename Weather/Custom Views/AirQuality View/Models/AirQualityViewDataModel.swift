//
//  AirQualityViewDataModel.swift
//  Weather
//
//  Created by Арсений Кухарев on 20.07.2023.
//

import Foundation
/**
 AirQualityView принимает эту модель в своём инициализаторе.
 В инициализатор принимает модели с разных сайтов
*/
struct AirQualityViewDataModel: AirQualityViewProtocol {
    let index: Int
    
    init(responce: OpenWeatherAirPollutionResponce) {
        self.index = responce.list?.first?.main?.aqi ?? 0
    }
}
