//
//  wind.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct Wind: Decodable {
    let speed: Double
    let deg: Int
    let gust: Double
}
