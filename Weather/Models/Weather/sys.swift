//
//  sys.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct Sys: Decodable {
    let type: Int?
    let id: Int?
    let message: String?
    let country: String?
    let sunrise: Int?
    let sunset: Int
}
