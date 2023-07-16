//
//  DegreesLabel.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 16.07.2023.
//

import UIKit

class DegreesLabel: UIView {

    //MARK: Properties
    let degree: String
    
    
    //MARK: - Init
    init(degree: Int) {
        self.degree = String(degree)
        super.init(frame: .zero)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Drawing
    override func draw(_ rect: CGRect) {
        let font = UIFont(name: "Avenir-Black", size: 1)
        
        let textLayer = CATextLayer()
        textLayer.string = degree + "º"
        textLayer.font = font
        textLayer.fontSize = rect.width * 0.5
        textLayer.frame = rect
        self.layer.addSublayer(textLayer)
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = rect
        gradientLayer.colors = [ #colorLiteral(red: 0.3294117647, green: 0.3411764706, blue: 0.3764705882, alpha: 1).cgColor, #colorLiteral(red: 0.6352941176, green: 0.6431372549, blue: 0.7098039216, alpha: 1).cgColor ]
        gradientLayer.locations = [0, 1]

        gradientLayer.mask = textLayer
        self.layer.addSublayer(gradientLayer)
    }
   
}
