//
//  rain.swift
//  Weather
//
//  Created by Арсений Кухарев on 07.07.2023.
//

import Foundation

struct Rain: Decodable {
    let volumeLast1hour: Double?
    let volumeLast3hour: Double?
    
    enum CodingKeys: String, CodingKey {
        case volumeLast1hour = "1h"
        case volumeLast3hour = "3h"
    }
}


