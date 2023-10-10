//
//  DescriptionWeatherLabel.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 16.07.2023.
//

import UIKit

class DescriptionWeatherLabel: UILabel {

    //MARK: Properties
    private let descriptionText: String
    
    
    //MARK: - Init
    init(text: String) {
        self.descriptionText = text
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - setupUI
    private func setupUI() {
        configureSelf()
    }
    
    private func configureSelf() {
        self.text = descriptionText
        self.textColor = #colorLiteral(red: 1, green: 0.9999999404, blue: 1, alpha: 1)
        
        let font = UIFont(name: "PingFangTC-Ultralight", size: 25)
        self.font = font
    }
    

    

}
