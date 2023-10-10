//
//  FeelsLikeLabel.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 16.07.2023.
//

import UIKit

class FeelsLikeLabel: UILabel {

    //MARK: Properties
    private let minTemp: Int
    private let maxTemp: Int
    private let feelsLikeTemp: Int
    

    //MARK: - Init
    init(minTemp: Int, maxTemp: Int, feelsLikeTemp: Int) {
        self.minTemp = minTemp
        self.maxTemp = maxTemp
        self.feelsLikeTemp = feelsLikeTemp
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
    }
    
    private func configureSelf() {
        self.attributedText = getAttributedString()
    }
    
    
    //MARK: - Work with text
    func getAttributedString() -> NSMutableAttributedString {
        let minString = String(minTemp)
        let maxString = String(maxTemp)
        let feelsLikeString = String(feelsLikeTemp)
        
        let leftString = minString + "º/" + maxString + "º | Feels like "
        let rightString = feelsLikeString + "º  |  "
        
        let leftAttributedString = NSAttributedString(string: leftString, attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6078431373, green: 0.6196078431, blue: 0.6784313725, alpha: 1)
        ])
        
        let rightAttributedString = NSAttributedString(string: rightString, attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        ])
        
        let mainString = NSMutableAttributedString()
        mainString.append(leftAttributedString)
        mainString.append(rightAttributedString)
        return mainString
    }
}
