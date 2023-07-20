//
//  WeatherProtocol.swift
//  Weather
//
//  Created by Арсений Кухарев on 18.07.2023.
//

import Foundation

protocol MainInfoViewProtocol {
    var currentTemp: Int { get }
    var minTemp: Int { get }
    var maxTemp: Int { get }
    var feelsLikeTemp: Int { get }
    var windSpeed: Int { get }
    var windDirection: Int { get }
    var description: String { get }
}
