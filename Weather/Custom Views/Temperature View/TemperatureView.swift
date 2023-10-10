//
//  MainInfoView.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 16.07.2023.
//

import UIKit

class TemperatureView: UIView {

    //MARK: Properties
    private var weatherImageView: WeatherImageView!
    private var degreesLabel: DegreesLabel!
    private var descriptionLabel: DescriptionWeatherLabel!
    private var feelsLikeLabel: FeelsLikeLabel!
    private var windLabel: WindLabel!
    
    private let degree: Int
    private let descriptionWeather: String
    private let imageID: Int
    private let minTemp: Int
    private let maxTemp: Int
    private let feelsLikeTemp: Int
    private let windSpeed: Int
    private let windDirection: Int
    
    
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
    }
    
    private func configureWeatherImageView() {
        weatherImageView = WeatherImageView(withId: imageID)
        self.addSubview(weatherImageView)
        
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weatherImageView.topAnchor.constraint(equalTo: self.topAnchor),
            weatherImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            weatherImageView.widthAnchor.constraint(equalTo: self.widthAnchor,multiplier: 0.4)
        ])
    }
    
    private func configureDegreesLabel() {
        degreesLabel = DegreesLabel(degree: degree)
        self.addSubview(degreesLabel)
        
        degreesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            degreesLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor),
            degreesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            degreesLabel.topAnchor.constraint(equalTo: self.topAnchor),
            degreesLabel.heightAnchor.constraint(equalTo: weatherImageView.heightAnchor, multiplier: 0.7),
        ])
     
        degreesLabel.layoutIfNeeded()
        degreesLabel.configureView()
    }
    
    private func configureDescriptionLabel() {
        descriptionLabel = DescriptionWeatherLabel(text: descriptionWeather)
        self.addSubview(descriptionLabel)
        
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            descriptionLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor),
            descriptionLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: degreesLabel.bottomAnchor),
            descriptionLabel.heightAnchor.constraint(equalTo: weatherImageView.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func configureFeelsLikeLabel() {
        feelsLikeLabel = FeelsLikeLabel(minTemp: minTemp, 
                                        maxTemp: maxTemp,
                                        feelsLikeTemp: feelsLikeTemp)
        self.addSubview(feelsLikeLabel)
        
        feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feelsLikeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            feelsLikeLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor),
            feelsLikeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    private func configureWindLabel() {
        windLabel = WindLabel(speed: windSpeed, direction: windDirection)
        self.addSubview(windLabel)
        
        windLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            windLabel.leadingAnchor.constraint(equalTo: feelsLikeLabel.trailingAnchor),
            windLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            windLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            windLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor)
        ])
    }
    
}


//MARK: - ConfigureViewProtocol
extension TemperatureView: ConfigureViewProtocol {
    public func configureView() {
        setupUI()
    }
}
