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
                                       name: .geoArray,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .weatherArray,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .singleGeo,
                                       object: nil)
        notificationCenter.addObserver(self,
                                       selector: #selector(reseveNotification(_:)),
                                       name: .singleWeather,
                                       object: nil)
    }
    
    @objc
    private func reseveNotification(_ sender: Notification) {
        switch sender.name {
        
        case .weatherArray:
            /// Вызывается:
            /// - PageVC как только скачается из интернета
            guard let responces = sender.userInfo?[NSNotification.keyName] as? [OpenWeatherResponce] else { return }
            self.weatherResponces.removeAll()
            self.weatherResponces = responces
            self.tableView.reloadData()
            
        case .geoArray:
            /// Вызывается:
            /// - CityChooserVC когда удаляем ячейку
            /// - PageVC как только скачается из CD
            guard let geo = sender.userInfo?[NSNotification.keyName] as? [GeoResponce] else { return }
            self.geoResponces = geo
            self.tableView.reloadData()
            
        case .singleWeather:
            /// Вызывается:
            /// - ModalVC когда сохранили город
            guard let responce = sender.userInfo?[NSNotification.keyName] as? OpenWeatherResponce else { return }
            self.weatherResponces.append(responce)
            self.tableView.reloadData()
            
        case .singleGeo:
            /// Вызывается:
            /// -  ModalVC когда сохранили город
            guard let responce = sender.userInfo?[NSNotification.keyName] as? GeoResponce else { return }
            self.geoResponces.append(responce)
            self.searchController.isActive = false
            self.tableView.reloadData()

        default: return
        }
    }
}
