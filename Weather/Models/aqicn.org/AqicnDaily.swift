//
//  AqicnDaily.swift
//  Weather
//
//  Created by Арсений Кухарев on 25.07.2023.
//

import Foundation

struct AqicnDaily: Decodable {
    let o3: [AqicnDailyValue]?
    let pm10: [AqicnDailyValue]?
    let pm25: [AqicnDailyValue]?
}
