//
//  CircleLayer.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 20.07.2023.
//

import UIKit

class CircleView: UIImageView {

    //MARK: Properties
    private let index: CGFloat
    
    
    //MARK: - Init
    init(index: CGFloat) {
        self.index = index
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - SetupUI
    private func setupUI() {
        let img = CircleRenderer().createCircle(in: self.bounds,
                                                    forIndex: index)
        self.image = img
    }
        
}


//MARK: - ConfigureViewProtocol
extension CircleView: ConfigureViewProtocol {
    public func configureView() {
        setupUI()
    }
    
    
}
