//
//  WeatherResponce.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct WeatherResponce: Decodable {
    let coordinates: Coordinates?
    let weatherDescription: [WeatherDescription]?
    let tempAndPressure: TempAndPressure?
    let visibility: Int?
    let wind: Wind?
    let rain: Rain?
    let clouds: Clouds?
    let sunriseSunset: SunriseSunset?
    
    enum CodingKeys: String, CodingKey {
        case visibility, wind, rain, clouds
        case coordinates = "coord"
        case weatherDescription = "weather"
        case tempAndPressure = "main"
        case sunriseSunset = "sys"
    }
}
