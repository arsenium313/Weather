//
//  PageVC+WorkWithPages.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.10.2023.
//

import UIKit

extension PageVC {
    
    /// Создаём WeatherHomeVC, настраиваем его bundleView и кладем в массив pages
    public func appendPage(geo: GeoResponce, weatherResponce tuple: // зачем вообще метод?
                           (OpenWeatherResponce, OpenWeatherAirPollutionResponce)) {
        let weatherVC = WeatherHomeVC(geoResponce: geo,
                                      weatherResponce: tuple.0,
                                      airPollutionResponce: tuple.1)
        self.pages.append(weatherVC)
    }
    
    
    
    /// Возвращает индекс в массиве GeoResponce, если не найдено, то вернет 0
    internal func getFirstToShowIndex() -> Int {
        if let firstGeo = DataManager.shared.fetchFirstToShow() {
            return self.geoResponces.firstIndex(where: {
                $0.lat == firstGeo.lat && $0.lon == firstGeo.lon }) ?? 0
        }
        return 0
    }
    
    /// Обновляет CurrentPage для указанного индекса
    public func updatePageControlCurrentPage(to index: Int) {
        let number = pageControl.numberOfPages
        pageControl.numberOfPages = 0
        pageControl.numberOfPages = number
        pageControl.currentPage = index
    }
}
