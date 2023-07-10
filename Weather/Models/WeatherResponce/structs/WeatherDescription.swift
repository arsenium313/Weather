//
//  weather.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct WeatherDescription: Decodable {
    let groupOfWeather: String?
    let description: String?
    let iconId: String?
    
    enum CodingKeys: String, CodingKey {
        case groupOfWeather = "main"
        case description
        case iconId = "icon"
    }
}
