//
//  OpenWeatherAirPollutionResponce.swift
//  Weather
//
//  Created by Арсений Кухарев on 25.07.2023.
//

import Foundation

struct OpenWeatherAirPollutionResponce: Decodable {
    let coord: Coordinates?
    let list: [OpenWeatherList]?
}
