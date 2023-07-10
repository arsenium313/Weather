//
//  clouds.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

struct Clouds: Decodable {
    let persentageOfCloudiness: Int?
    
    enum CodingKeys: String, CodingKey {
        case persentageOfCloudiness = "all"
    }
}
