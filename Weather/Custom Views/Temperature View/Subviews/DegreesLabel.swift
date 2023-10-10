//
//  DegreesLabel.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 16.07.2023.
//

import UIKit

class DegreesLabel: UILabel {

    //MARK: Properties
   private let degree: String
    
    
    //MARK: - Init
    init(degree: Int) {
        self.degree = String(degree)
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
        self.text = degree + "°"
        self.adjustsFontSizeToFitWidth = true
        self.textAlignment = .center
        self.font = .systemFont(ofSize: 100)
        self.textColor = UIColor.createGradientColor(in: self.bounds,
                                                     for: [#colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1).cgColor,
                                                           #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1).cgColor])
    }
   
}

//MARK: - ConfigureViewProtocol
extension DegreesLabel: ConfigureViewProtocol {
    func configureView() {
        setupUI()
    }
}
