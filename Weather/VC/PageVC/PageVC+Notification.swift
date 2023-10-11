//
//  PageVC+WorkWithNotification.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.10.2023.
//

import UIKit

extension PageVC {
    
    /// Отправляем Notification .weather
    internal func sendNotification(withData
                                   data: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]) {
        let weatherDictionary: [String : [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]]
        = ["weather" : data]
        
        self.notificationCenter.post(name: .weather,
                                     object: self,
                                     userInfo: weatherDictionary)
    }
    
    /// Добавляем PageVC в подписчики нотификации
    internal func addNotificationObserver() {
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .geo,
                                       object: nil)
    }
    
    /**
     Для .geo:
     – Заполняем массив geoResponces
     – Устанавливаем количество точек в pageControl
     */
    @objc
    private func reseveNotification(_ sender: Notification) {
        switch sender.name {
        case .geo:
            guard let geo = sender.userInfo?["geo"] as? [GeoResponce] else { return }
            self.geoResponces = geo
            self.pageControl.numberOfPages = geo.count
        default: return
        }
    }

}
