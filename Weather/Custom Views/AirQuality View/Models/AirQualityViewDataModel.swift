//
//  AirQualityViewDataModel.swift
//  Weather
//
//  Created by Арсений Кухарев on 20.07.2023.
//

import Foundation
/**
 AirQualityView принимает эту модель в своём инициализаторе.
 Под каждый сайт делать отдельный инициализатор
*/
struct AirQualityViewDataModel: AirQualityViewProtocol {
    let index: Int
    
    init(responce: OpenWeatherAirPollutionResponce) {
        self.index = responce.list?.first?.main?.aqi ?? 0
    }
}
