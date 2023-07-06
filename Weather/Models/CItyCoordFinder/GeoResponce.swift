//
//  Geo.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct GeoResponce: Decodable {
    let name: String?
    let local_names: LocalNames?
    let lat: Double?
    let lon: Double?
    let country: String?
    let state: String?
}
