//
//  WeatherResponce.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct OpenWeatherResponce: Decodable {
    let coordinates: Coordinates?
    let weatherDescription: [OpenWeatherWeatherDescription]?
    let tempAndPressure: OpenWeatherTempAndPressure?
    let visibility: Int?
    let wind: OpenWeatherWind?
    let rain: OpenWeatherRain?
    let clouds: OpenWeatherClouds?
    let sunriseSunset: OpenWeatherSunriseSunset?
    
    enum CodingKeys: String, CodingKey {
        case visibility, wind, rain, clouds
        case coordinates = "coord"
        case weatherDescription = "weather"
        case tempAndPressure = "main"
        case sunriseSunset = "sys"
    }
}
