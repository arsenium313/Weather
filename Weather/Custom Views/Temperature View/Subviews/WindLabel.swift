//
//  WindLabel.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 16.07.2023.
//

import UIKit

class WindLabel: UILabel {
    
    //MARK: Properties
    private let speed: Int
    private let direction: Int
    
    
    //MARK: - Init
    init(speed: Int, direction: Int) {
        self.speed = speed
        self.direction = direction
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
        self.textAlignment = .right
        self.attributedText = getAttributedString()
    }
    
}


//MARK: - ConfigureViewProtocol
extension WindLabel: ConfigureViewProtocol {
    public func configureView() {
        setupUI()
    }
}


//MARK: - Work with text
extension WindLabel {
    ///Возвращает строку формата – "Wind"  / Скорость ветра /  Направление ветра
    private func getAttributedString() -> NSMutableAttributedString {
        let fontSize = self.bounds.height * 0.3
        let firstString = "Wind "
        let secondString = String(speed) + " M/S "
        let thirdString = getStringDirection()
        
        let firstAttributedString = NSAttributedString(string: firstString, attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6078431373, green: 0.6196078431, blue: 0.6784313725, alpha: 1),
            .font : UIFont.systemFont(ofSize: fontSize)
        ])
        let secondAttributedString = NSAttributedString(string: secondString, attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            .font : UIFont.systemFont(ofSize: fontSize)
        ])
        let thirdAttributedString = NSAttributedString(string: thirdString, attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 0.6078431373, green: 0.6196078431, blue: 0.6784313725, alpha: 1),
            .font : UIFont.systemFont(ofSize: fontSize)
        ])
        
        let mainString = NSMutableAttributedString()
        mainString.append(firstAttributedString)
        mainString.append(secondAttributedString)
        mainString.append(thirdAttributedString)
        return mainString
    }
    
    private func getStringDirection() -> String {
        switch direction {
        case 12...33 : return "NNE"
        case 34...56 : return "NE"
        case 57...78 : return "ENE"
        case 79...101 : return "E"
        case 102...123 : return "ESE"
        case 124...146 : return "SE"
        case 147...168 : return "SSE"
        case 169...191 : return "S"
        case 192...213 : return "SSW"
        case 214...236 : return "SW"
        case 237...258 : return "WSW"
        case 259...281 : return "W"
        case 282...303 : return "WNW"
        case 304...326  : return "NW"
        case 327...348 : return "NNW"
        case 349...360, 0...11 : return "N"
        default: return "nil"
        }
    }
}

