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
    public var primaryText = "" { willSet { listConfig.text = newValue } }
    public var secondaryText = "" { willSet { listConfig.secondaryText = newValue } }
    

    
    //MARK: - SetupUI
    func setupUI() {
        configureSelf()
    }
    
    private func configureSelf() {
        self.contentConfiguration = listConfig
        self.showsReorderControl = true
    }

}
