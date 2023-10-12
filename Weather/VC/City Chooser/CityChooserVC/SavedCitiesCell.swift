//
//  SavedCitiesCell.swift
//  Weather
//
//  Created by Арсений Кухарев on 11.10.2023.
//

import UIKit

class SavedCitiesCell: UITableViewCell {
    
    //MARK: Properties
    static let identifier = "SavedCitiesCell"
    private var listConfig = UIListContentConfiguration.subtitleCell()
    
    
    //MARK: - SetupUI
    public func setupUI(withGeo geo: GeoResponce,
                        withWeather weather: OpenWeatherResponce?) {
        
        listConfig.text = geo.nameOfLocation ?? "--"
        listConfig.secondaryText = "\(weather?.tempAndPressure?.temp ?? -100). \(weather?.weatherDescription?.first?.description ?? "nil")"
        configureSelf()
    }

    private func configureSelf() {
        self.contentConfiguration = listConfig
        self.showsReorderControl = true
    }

}


 
