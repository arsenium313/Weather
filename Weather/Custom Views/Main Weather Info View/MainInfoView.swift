//
//  MainInfoView.swift
//  GradientTest
//
//  Created by Арсений Кухарев on 16.07.2023.
//

import UIKit

class MainInfoView: UIView {

    //MARK: - Properties
    private lazy var guide = self.layoutMarginsGuide
    
    private var weatherImageView: UIImageView!
    private var degreesLabel: DegreesLabel!
    private var descriptionLabel: DescriptionWeatherLabel!
    private var feelsLikeLabel: FeelsLikeLabel!
    private var windLabel: WindLabel!
    
    private let degree = 25 // из JSON
    private let descriptionWeather = "partly Cloudy"// из JSON
    private let minTemp = 21 // из JSON
    private let maxTemp = 33 // из JSON
    private let feelsLikeTemp = 27 // из JSON
    private let windSpeed = 10 // из JSON
    private let windDirection = 62 // из JSON
    
    
    //MARK: - Init
    override init(frame: CGRect) { // какие данные будут падать сюда? weatherResponce!
        super.init(frame: .zero)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureImageView()
        configureDegreesLabel()
        configureDescriptionLabel()
        configureFeelsLikeLabel()
        configureWindLabel()
    }
    
    private func configureSelf() {
        self.backgroundColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 0)
//        self.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
//        self.layer.borderWidth = 3
    }
    
    private func configureImageView() {
        let image = UIImage(named: "icon_1")
        weatherImageView = UIImageView(image: image)
        self.addSubview(weatherImageView)
        weatherImageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            weatherImageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            weatherImageView.topAnchor.constraint(equalTo: self.topAnchor),
            weatherImageView.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.7),
            weatherImageView.widthAnchor.constraint(equalTo: weatherImageView.heightAnchor)
        ])
      //  weatherImageView.backgroundColor = .orange
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
      //  degreesLabel.backgroundColor = .blue
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
       // descriptionLabel.backgroundColor = .red
    }
    
    private func configureFeelsLikeLabel() {
        feelsLikeLabel = FeelsLikeLabel(minTemp: minTemp, maxTemp: maxTemp, feelsLikeTemp: feelsLikeTemp)
        self.addSubview(feelsLikeLabel)
        feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feelsLikeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 10),
            feelsLikeLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor),
            feelsLikeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        //feelsLikeLabel.backgroundColor = .green
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
       // windLabel.backgroundColor = .purple
    }
}

