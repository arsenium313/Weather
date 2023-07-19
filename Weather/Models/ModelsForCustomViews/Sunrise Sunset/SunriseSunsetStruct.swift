//
//  SunriseSunsetStruct.swift
//  Weather
//
//  Created by Арсений Кухарев on 19.07.2023.
//

import Foundation

struct SunriseSunsetStruct: SunriseSunsetViewProtocol {
    var startTimeStamp: Int
    var endTimeStamp: Int
    
    init(weatherResponce: WeatherResponce) {
        self.startTimeStamp = weatherResponce.sunriseSunset?.sunriseTime ?? 0
        self.endTimeStamp = weatherResponce.sunriseSunset?.sunsetTime ?? 0
    }
    
    
}
