//
//  OpenWeatherList.swift
//  Weather
//
//  Created by Арсений Кухарев on 25.07.2023.
//

import Foundation

struct OpenWeatherList: Decodable {
    let dt: Int?
    let main: OpenWeatherMain?
    let components: OpenWeatherComponents?
}
