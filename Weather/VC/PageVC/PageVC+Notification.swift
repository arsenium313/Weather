//
//  PageVC+WorkWithNotification.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.10.2023.
//

import UIKit

extension PageVC {
    
    internal func sendNotification(withData data: [OpenWeatherResponce]) {
        /// Отправляем:
        /// - CityChooserVC
        self.notificationCenter.post(name: .weatherArray,
                                     object: self,
                                     userInfo: [NSNotification.keyName : data])
    }
    
    /// Добавляем PageVC в подписчики нотификации
    internal func addNotificationObserver() {
        
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .geoArray,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .singleGeo,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .weatherTuple,
                                       object: nil)
    }
    

    @objc
    private func reseveNotification(_ sender: Notification) {
        switch sender.name {
        case .geoArray:
            /// Вызывается:
            /// - PageVC как только скачали из CD
            /// - CityChooser когда удалили ячейку
            guard let geoArray = sender.userInfo?[NSNotification.keyName] as? [GeoResponce] else { return }
            self.geoResponces.removeAll()
            self.geoResponces = geoArray
            self.pageControl.numberOfPages = geoResponces.count
            
        case .singleGeo:
//            /// Вызывается
//            /// - CityChooserVC когда удалили ячейку
            guard let singleGeo = sender.userInfo?[NSNotification.keyName] as? GeoResponce else { return }
//            self.geoResponces.append(singleGeo)
//            self.pageControl.numberOfPages = geoResponces.count
//            
        case .weatherTuple:
            /// Вызывается:
            /// - ModalVC когда сохранили город
            // надо сделать метод который будет создавать WeatherVC из входящего тупла и добавлять его в массив pages
            // + надо принимать и geo для имени
            guard let dataTuple = sender.userInfo?[NSNotification.keyName] as? (GeoResponce,
                                                                                OpenWeatherResponce,
                                                                                OpenWeatherAirPollutionResponce) else { return }
            self.geoResponces.append(dataTuple.0)
            self.pageControl.numberOfPages = geoResponces.count
            
            let vc = WeatherHomeVC(geoResponce: dataTuple.0,
                                   weatherResponce: dataTuple.1,
                                   airPollutionResponce: dataTuple.2)
            self.pages.append(vc)
            
            
            
        default: return
        }
    }


}
