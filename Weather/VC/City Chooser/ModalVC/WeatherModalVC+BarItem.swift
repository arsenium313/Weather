//
//  WeatherModalVC+BarItem.swift
//  Weather
//
//  Created by Арсений Кухарев on 12.10.2023.
//

import UIKit

extension WeatherModalVC {
    
    internal var addBarButton: UIBarButtonItem {
        let image = UIImage(systemName: "square.and.arrow.down")
        let button = UIBarButtonItem(image: image, 
                                     style: .plain,
                                     target: self,
                                     action: #selector(barButtonItemClicked(_:)))
        
        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return button
    }
    
    
    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        
        /// Создаём элемент в CD
        DataManager.shared.createGeoEntity(geo: geoResponce,
                                           index: index)
        
        /// Если попытались сохранить без скачанных данных:
        guard let weatherResponce = weatherResponce else {
            dismiss(animated: true)
            return
        }
        
        /// Принимает:
        /// - CityChooserVC
        /// - PageVC
        notificationCenter.post(name: .singleGeo,
                                object: self,
                                userInfo: [NSNotification.keyName : geoResponce])
        
        /// Принимает:
        /// - CityChooserVC
        notificationCenter.post(name: .singleWeather,
                                object: self,
                                userInfo: [NSNotification.keyName : weatherResponce])
       
        /// Принимает:
        /// - PageVC
        notificationCenter.post(name: .weatherTuple,
                                object: self,
                                userInfo: [NSNotification.keyName : (geoResponce,
                                                                     weatherResponce,
                                                                     airPollutionResponce)])
    
        dismiss(animated: true)
    }
}
