//
//  IndexLabel.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 20.07.2023.
//

import UIKit

class IndexLabel: UILabel {

    //MARK: Properties
    private let index: Int
    
    
    //MARK: - Init
    init(index: Int) {
        self.index = index
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
        self.textAlignment = .center
        self.attributedText = getAttributedStringFor(index)
        self.numberOfLines = 0
        self.adjustsFontSizeToFitWidth = true
    }
    
    
    //MARK: - Work with attributed string
    private func getAttributedStringFor(_ index: Int) -> NSMutableAttributedString {
        let indexString = String(index) + "\n"
        let indexAttributedString = NSAttributedString(string: indexString, attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 50) // Сделать автоматически
        ])
        
        let categoryString = getAqiCategoryFor(index)
        let categoryAttributedString = NSAttributedString(string: categoryString, attributes: [
            NSAttributedString.Key.foregroundColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1),
            NSAttributedString.Key.font : UIFont(name: "Avenir-Light", size: 30)! // Сделать автоматически
        ])
        
        let totalString = NSMutableAttributedString()
        totalString.append(indexAttributedString)
        totalString.append(categoryAttributedString)
        return totalString
    }
    
    private func getAqiCategoryFor(_ index: Int) -> String {
        switch index {
        case 1: return "Good"
        case 2: return "Fair"
        case 3: return "Moderate"
        case 4: return "Poor"
        case 5: return "Very Poor"
        default: return "nil"
        }
    }
    
}
