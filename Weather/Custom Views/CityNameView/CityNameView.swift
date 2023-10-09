//
//  CityNameView.swift
//  Weather
//
//  Created by Арсений Кухарев on 09.10.2023.
//

import UIKit

class CityNameView: UIView {

    //MARK: Properties
    private let cityName: String
    private let cityNamelabel = UILabel()
    
    
    //MARK: - Init
    init(dataModel: CityNameViewDataModel) {
        self.cityName = dataModel.cityName
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetupUI
    internal func setupUI() {
        configureSelf()
        configureCityNameLabel()
    }
    
    private func configureSelf() {
        self.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.layer.borderWidth = 3
    }
    
    private func configureCityNameLabel() {
        self.addSubview(cityNamelabel)
        cityNamelabel.frame = self.bounds
        cityNamelabel.text = cityName
        cityNamelabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cityNamelabel.adjustsFontSizeToFitWidth = true
        cityNamelabel.textAlignment = .center
        cityNamelabel.font = .systemFont(ofSize: 100)
    }
}
