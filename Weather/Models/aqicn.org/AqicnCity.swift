//
//  AqicnCity.swift
//  Weather
//
//  Created by Арсений Кухарев on 25.07.2023.
//

import Foundation

struct AqicnCity: Decodable {
    let name: String?
    let url: String?
    let geo: [Double]?
    let location: String?
}
