//
//  AqicnDailyValues.swift
//  Weather
//
//  Created by Арсений Кухарев on 25.07.2023.
//

import Foundation

struct AqicnDailyValue: Decodable {
    let avg: Int?
    let day: String?
    let max: Int?
    let min: Int?
}
