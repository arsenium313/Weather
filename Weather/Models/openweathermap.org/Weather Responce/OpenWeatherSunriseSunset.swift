//
//  sys.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct OpenWeatherSunriseSunset: Decodable {
    let countryCode: String?
    let sunriseTime: Int?
    let sunsetTime: Int?
    
    enum CodingKeys: String, CodingKey {
        case countryCode = "country"
        case sunriseTime = "sunrise"
        case sunsetTime = "sunset"
    }
}
