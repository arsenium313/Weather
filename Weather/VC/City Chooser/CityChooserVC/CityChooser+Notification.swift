//
//  CityChooser+Notification.swift
//  Weather
//
//  Created by Арсений Кухарев on 11.10.2023.
//

import UIKit
extension CityChooserVC {
    
    internal func addNotificationObserver() {
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .geo,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .weather,
                                       object: nil)
    }
    
    @objc
    private func reseveNotification(_ sender: Notification) {
        switch sender.name {
            
        case .weather:
            guard let weatherResponce = sender.userInfo?["weather"]
                    as? [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] else { return }
            self.weatherResponces = weatherResponce
            self.tableView.reloadData()
            
        case .geo:
            guard let geo = sender.userInfo?["geo"] as? [GeoResponce] else { return }
            self.geoResponces = geo
            self.tableView.reloadData()
            
        default: return
        }
    }
}
