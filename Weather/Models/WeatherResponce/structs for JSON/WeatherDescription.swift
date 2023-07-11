//
//  weather.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct WeatherDescription: Decodable {
    let id: Int?
    let mainGroup: String?
    let description: String?
    let iconId: String?
    
    enum CodingKeys: String, CodingKey {
        case description, id
        case mainGroup = "main"
        case iconId = "icon"
    }
}
