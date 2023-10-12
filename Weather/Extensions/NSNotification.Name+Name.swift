//
//  NSNotification.Name+Name.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.09.2023.
//

import Foundation
/// Для точечного синтаксиса
extension NSNotification.Name {
    static let weatherArray = NSNotification.Name.init("addWeatherResponce2")
    static let geoArray = NSNotification.Name.init("geoArray")
    static let singleGeo = NSNotification.Name.init("singleGeo")
    static let singleWeather = NSNotification.Name.init("singleWeather")
    static let weatherTuple = NSNotification.Name.init("weatherTuple")
}

extension NSNotification {
    static let keyName = "keyName"
}
