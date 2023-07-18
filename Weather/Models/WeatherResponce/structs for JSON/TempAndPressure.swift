//
//  main.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct TempAndPressure: Decodable {
    let temp: Double?
    let feelsLike: Double?
    let tempMin: Double?
    let tempMax: Double?
    let pressureHPa: Int?
    let humidity: Int?
    let seaLevelHPa: Int?
    let grndLevelHPa: Int?
    
    enum CodingKeys: String, CodingKey {
        case temp, humidity
        case pressureHPa = "pressure"
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case seaLevelHPa = "sea_level"
        case grndLevelHPa = "grnd_level"
    }    
}

