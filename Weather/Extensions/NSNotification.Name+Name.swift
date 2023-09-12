//
//  NSNotification.Name+Name.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.09.2023.
//

import Foundation
/// Для точечного синтаксиса
extension NSNotification.Name {
    static let addWeatherResponce = NSNotification.Name.init("addWeatherResponce")
    static let addGeoResponce = NSNotification.Name.init("addGeoResponce")
}
