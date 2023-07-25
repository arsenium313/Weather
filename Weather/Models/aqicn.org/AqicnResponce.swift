//
//  AqiResponce.swift
//  Weather
//
//  Created by Арсений Кухарев on 25.07.2023.
//

import Foundation
///Модель из JSON,  сайта aqicn.org
struct AqicnResponce: Decodable {
    let status: String
    let data: AqicnData
}
