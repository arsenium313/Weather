//
//  AqicnIaqi.swift
//  Weather
//
//  Created by Арсений Кухарев on 25.07.2023.
//

import Foundation

struct AqicnIaqi: Decodable {
    let dew: AqicnV?
    let h: AqicnV?
    let p: AqicnV?
    let r: AqicnV?
    let so2 : AqicnV?
    let t: AqicnV?
    let w: AqicnV?
}
