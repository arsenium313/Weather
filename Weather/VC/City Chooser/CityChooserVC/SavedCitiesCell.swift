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
    
    public var primaryText = "" { willSet { listConfig.text = newValue } }
    public var secondaryText = "" { willSet { listConfig.secondaryText = newValue } }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
    }
    
    private func configureSelf() {
        self.contentConfiguration = listConfig
        self.showsReorderControl = true
    }

}


//MARK: - ConfigureViewProtocol
extension SavedCitiesCell: ConfigureViewProtocol {
   public func configureView() {
        configureSelf()
    }
}
 
