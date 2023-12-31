//
//  wind.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct OpenWeatherWind: Decodable {
    let speed: Double?
    let directionInDegrees: Int?
    let gust: Double?
    
    enum CodingKeys: String, CodingKey {
        case speed, gust
        case directionInDegrees = "deg"
    }
}


