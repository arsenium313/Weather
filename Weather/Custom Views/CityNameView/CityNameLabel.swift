//
//  CityNameView.swift
//  Weather
//
//  Created by Арсений Кухарев on 09.10.2023.
//

import UIKit

class CityNameLabel: UILabel {

    //MARK: Properties
    private let cityName: String
    
    
    //MARK: - Init
    init(dataModel: CityNameLabelDataModel) {
        self.cityName = dataModel.cityName
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
    }
    
    private func configureSelf() {
        let fontSize = self.bounds.height
        self.text = cityName
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
        self.font = .systemFont(ofSize: fontSize)
        self.textColor = UIColor.createGradientColor(in: self.bounds,
                                                     for: [#colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1).cgColor,
                                                           #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1).cgColor])
    }
}


//MARK: - ConfigureViewProtocol
extension CityNameLabel: ConfigureViewProtocol {
    public func configureView() {
        setupUI()
    }
}
