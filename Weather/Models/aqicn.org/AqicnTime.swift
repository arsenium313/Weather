//
//  AqicnTime.swift
//  Weather
//
//  Created by Арсений Кухарев on 25.07.2023.
//

import Foundation

struct AqicnTime: Decodable {
    let v: Int?
    let s: String?
    let tz: String?
    let iso: String?
}
