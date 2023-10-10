//
//  CustomCell.swift
//  Weather
//
//  Created by Арсений Кухарев on 17.09.2023.
//

import UIKit

class CustomCell: UICollectionViewCell {
    
    // MARK: SetupUI
    public func setupUI<T>(for kind: CellIdentifier, responce: T) {
        
        switch kind {
        case .title:
            guard let responce = responce as? GeoResponce else { return }
            configureTitleView(responce)
        case .weather:
            guard let responce = responce as? OpenWeatherResponce else { return }
            configureWeatherView(responce)
        case .sun:
            guard let responce = responce as? OpenWeatherResponce else { return }
            configureSunView(responce)
        case .airPollution:
            guard let responce = responce as? OpenWeatherAirPollutionResponce else { return }
            configureAirPollutionView(responce)
        case .blank:
            configureBlankView()
        }
    }
    
    private func constraints(view: UIView) {
        self.contentView.addSubview(view)
        view.frame = self.contentView.bounds
    }
    
    
    // MARK: - Configure Views
    private func configureTitleView(_ responce: GeoResponce) {
        let dataModel = CityNameLabelDataModel(openWeatherResponce: responce)
        let customView = CityNameLabel(dataModel: dataModel)
        constraints(view: customView)
        customView.configureView()
    }
    
    private func configureWeatherView(_ responce: OpenWeatherResponce) {
        let dataModel = TemperatureViewDataModel(openWeatherResponce: responce)
        let customView = TemperatureView(dataModel)
        constraints(view: customView)
        customView.configureView()
    }
    
    private func configureSunView(_ responce: OpenWeatherResponce) {
        let dataModel = SunriseSunsetViewDataModel(openWeatherResponce: responce)
        let customView = SunriseSunsetView(dataModel)
        
        constraints(view: customView)
        customView.configureView()
    }
    
    private func configureAirPollutionView(_ responce: OpenWeatherAirPollutionResponce) {
        let dataModel = AirQualityViewDataModel(openWeatherResponce: responce)
        let customView = AirQualityView(dataModel: dataModel)
        
        constraints(view: customView)
        customView.configureView()
    }
    
    private func configureBlankView() {
        // 🪣
    }
}
