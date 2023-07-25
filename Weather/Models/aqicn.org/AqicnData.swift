//
//  AqicnData.swift
//  Weather
//
//  Created by Арсений Кухарев on 25.07.2023.
//

import Foundation

struct AqicnData: Decodable {
    let idx: Int?
    let aqi: Int?
    let dominentpol: String?
    let time: AqicnTime?
    let city: AqicnCity?
    let attributions: [AqicnAttributions]?
    let iaqi: AqicnIaqi?
    let debug: AqicnDebug?
    let forecast: AqicnForecast?
}
