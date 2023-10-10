//
//  PageVC+WorkWithNotification.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.10.2023.
//

import UIKit

extension PageVC {
    
    /// Отправляем Notification ___________ЗАЧЕМ??? куда???
    internal func configureNotification() {
        let weatherDictionary: [String : [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]]
        = ["weather" : weatherResponces]
        self.notificationCenter.post(name: .addWeatherResponce,
                                     object: self,
                                     userInfo: weatherDictionary)
    }
    
    internal func addNotificationObserver() {
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .addGeoResponce,
                                       object: nil)
    }
    
    @objc
    internal func reseveNotification(_ sender: Notification) {
        switch sender.name {
        case .addGeoResponce:
            guard let geo = sender.userInfo?["geo"] as? [GeoResponce] else { return }
            self.geoResponces = geo
            self.pageControl.numberOfPages = geo.count
        default: return
        }
    }
    
    
    
    
}
