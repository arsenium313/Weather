//
//  MainInfoView.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 16.07.2023.
//

import UIKit

class TemperatureView: UIView {

    //MARK: Properties
    internal var weatherImageView: WeatherImageView!
    internal var degreesLabel: DegreesLabel!
    internal var descriptionLabel: DescriptionWeatherLabel!
    internal var feelsLikeLabel: FeelsLikeLabel!
    internal var windLabel: WindLabel!
    
    internal let degree: Int
    internal let descriptionWeather: String
    internal let imageID: Int
    internal let minTemp: Int
    internal let maxTemp: Int
    internal let feelsLikeTemp: Int
    internal let windSpeed: Int
    internal let windDirection: Int
    
    
    //MARK: - Init
    init(_ dataModel: TemperatureViewDataModel) {
        self.degree = dataModel.currentTemp
        self.descriptionWeather = dataModel.description
        self.minTemp = dataModel.minTemp
        self.maxTemp = dataModel.maxTemp
        self.feelsLikeTemp = dataModel.feelsLikeTemp
        self.windSpeed = dataModel.windSpeed
        self.windDirection = dataModel.windDirection
        self.imageID = dataModel.imageID
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureWeatherImageView()
        configureDegreesLabel()
        configureDescriptionLabel()
        configureFeelsLikeLabel()
        configureWindLabel()
        configureSubviews()
    }
    
    /// Настраиваем UI у subviews, все bounds известны
    private func configureSubviews() {
        self.layoutIfNeeded()
        
        degreesLabel.configureView()
        descriptionLabel.configureView()
        feelsLikeLabel.configureView()
        windLabel.configureView()
    }
}


//MARK: - ConfigureViewProtocol
extension TemperatureView: ConfigureViewProtocol {
    public func configureView() {
        setupUI()
    }
}
