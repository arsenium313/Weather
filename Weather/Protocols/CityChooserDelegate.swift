//
//  CityChooserDelegate.swift
//  Weather
//
//  Created by Арсений Кухарев on 07.07.2023.
//

import Foundation

protocol CityChooserDelegate: AnyObject {
    func passGeoResponce(_ geo: GeoResponce)
}
