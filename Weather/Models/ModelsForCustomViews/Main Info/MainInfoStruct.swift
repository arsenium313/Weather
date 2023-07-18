//
//  MainInfoResponceStruct.swift
//  Weather
//
//  Created by Арсений Кухарев on 18.07.2023.
//

import Foundation

struct MainInfoForViewStruct: MainInfoViewProtocol {
    let currentTemp: Int
    let minTemp: Int
    let maxTemp: Int
    let feelsLikeTemp: Int
    let windSpeed: Int
    let windDirection: Int
    let description: String
    
    init(responce:  WeatherResponce) {
        self.currentTemp = Int(responce.tempAndPressure?.temp?.rounded(.awayFromZero) ?? 0)
        self.minTemp = Int(responce.tempAndPressure?.tempMin?.rounded(.awayFromZero) ?? 0)
        self.maxTemp = Int(responce.tempAndPressure?.tempMax?.rounded(.awayFromZero) ?? 0)
        self.feelsLikeTemp = Int(responce.tempAndPressure?.feelsLike?.rounded(.awayFromZero) ?? 0)
       
        self.description = responce.weatherDescription?.description ?? "--"
        
        self.windSpeed = Int(responce.wind?.speed?.rounded(.awayFromZero) ?? 0)
        self.windDirection = responce.wind?.directionInDegrees ?? 0
    }
    
    // для каждого сайта писать свой инит
}
