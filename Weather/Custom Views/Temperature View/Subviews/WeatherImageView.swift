//
//  WeatherImageView.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.10.2023.
//

import UIKit

class WeatherImageView: UIImageView {

    //MARK: Properties
    private let id: Int
    
    
    //MARK: - Init
    init(withId id: Int) {
        self.id = id
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
        self.contentMode = .scaleAspectFit
        
        let imgName = findImageFor(id: id)
        let img = UIImage(named: imgName)
        guard let img = img else { return }
        self.image = img
    }
    
}


//MARK: - Find Image Name
extension WeatherImageView {
    private func findImageFor(id: Int) -> String {
        switch id {
            
        case 800: return "800"
        case 801: return "801"
        case 802: return "802"
        case 803...899: return "803+Default"
            
        case 700...799: return "7x+default"
            
        case 600: return "600"
        case 601: return "601"
        case 602...699: return "602+default"

        case 500: return "500"
        case 501: return "501"
        case 502: return "502"
        case 503...599: return "503+default"
            
        case 300...399: return "3x+default"
            
        case 200: return "200"
        case 201...202: return "201+202"
        case 203...299: return "211+default"
        default: return "800"
        }
    }
}
