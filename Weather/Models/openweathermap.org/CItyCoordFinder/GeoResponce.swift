//
//  Geo.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct GeoResponce: Decodable {
    
    let nameOfLocation: String?
    let localizedNames: LocalNames?
    let lat: Double
    let lon: Double
    let country: String?
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case lat, lon, country, state
        case nameOfLocation = "name"
        case localizedNames = "local_names"
    }
}

