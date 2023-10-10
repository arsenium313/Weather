//
//  TemperatureView+LayoutSubviews.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.10.2023.
//

import UIKit

extension TemperatureView {
    internal func configureWeatherImageView() {
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
    
    internal func configureDegreesLabel() {
        degreesLabel = DegreesLabel(degree: degree)
        self.addSubview(degreesLabel)
        
        degreesLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            degreesLabel.leadingAnchor.constraint(equalTo: weatherImageView.trailingAnchor),
            degreesLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            degreesLabel.topAnchor.constraint(equalTo: self.topAnchor),
            degreesLabel.heightAnchor.constraint(equalTo: weatherImageView.heightAnchor, multiplier: 0.7),
        ])
    }
    
    internal func configureDescriptionLabel() {
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
    
    internal func configureFeelsLikeLabel() {
        feelsLikeLabel = FeelsLikeLabel(minTemp: minTemp,
                                        maxTemp: maxTemp,
                                        feelsLikeTemp: feelsLikeTemp)
        self.addSubview(feelsLikeLabel)
        
        feelsLikeLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            feelsLikeLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            feelsLikeLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.5),
            feelsLikeLabel.topAnchor.constraint(equalTo: weatherImageView.bottomAnchor),
            feelsLikeLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }
    
    internal func configureWindLabel() {
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
