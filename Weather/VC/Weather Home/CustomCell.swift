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
        let customView = UILabel()
        customView.text = responce.nameOfLocation
        customView.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        customView.adjustsFontSizeToFitWidth = true
        customView.textAlignment = .center
        customView.font = .systemFont(ofSize: 100)
        customView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        constraints(view: customView)
    }
    
    private func configureWeatherView(_ responce: OpenWeatherResponce) {
        let dataModel = TemperatureViewDataModel(openWeatherResponce: responce)
        let customView = TemperatureView(dataModel)
        customView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        constraints(view: customView)
    }
    
    private func configureSunView(_ responce: OpenWeatherResponce) {
        let dataModel = SunriseSunsetViewDataModel(openWeatherResponce: responce)
        let customView = SunriseSunsetView(dataModel)
        constraints(view: customView)
    }
    
    private func configureAirPollutionView(_ responce: OpenWeatherAirPollutionResponce) {
        let dataModel = AirQualityViewDataModel(openWeatherResponce: responce)
        let customView = AirQualityView(dataModel: dataModel)
        constraints(view: customView)
    }
    
    private func configureBlankView() {
        // 🪣
    }
}
