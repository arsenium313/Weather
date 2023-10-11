//
//  SuggestionCitiesCell.swift
//  Weather
//
//  Created by Арсений Кухарев on 07.07.2023.
//

import UIKit

class SuggestionCitiesCell: UITableViewCell {

    //MARK: Properties
    static let identifier = "SuggestionCitiesCell"
    private var listConfig = UIListContentConfiguration.subtitleCell()
  
    public func configureCell(with data: GeoResponce) {
        listConfig.text = data.nameOfLocation ?? "–"
        listConfig.secondaryText = "\(data.state ?? "–"). \(data.country ?? "–")"
        self.contentConfiguration = listConfig
    }
}

