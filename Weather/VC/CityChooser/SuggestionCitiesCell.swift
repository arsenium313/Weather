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
    var primaryText = "" { willSet { listConfig.text = newValue } }
    var secondaryText = "" { willSet { listConfig.secondaryText = newValue } }

    
    //MARK: - SetupUI
    func setupUI() {
        configureSelf()
    }
    
    private func configureSelf() {
        self.contentView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.contentConfiguration = listConfig
    }
    
}
