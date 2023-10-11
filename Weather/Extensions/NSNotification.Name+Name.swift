//
//  NSNotification.Name+Name.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.09.2023.
//

import Foundation
/// Для точечного синтаксиса
extension NSNotification.Name {
    static let weather = NSNotification.Name.init("addWeatherResponce")
    static let geo = NSNotification.Name.init("addGeoResponce")
}
