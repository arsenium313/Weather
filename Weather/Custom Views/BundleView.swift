//
//  MainWeatherView.swift
//  Weather
//
//  Created by Арсений Кухарев on 01.09.2023.
//

import UIKit

/// Содержит subviews с погодой
class BundleView: UIView { // будет не нужен!!!!!!!!!!!!!!!!!!
    
    // MARK: Properties
    private let cityNameLabel = UILabel()
    
    // создаем их в любом случае, если не пришла какая инфа, отрисовать "nil"
    private var temperatureView: TemperatureView!
    private var sunriseSunsetView: SunriseSunsetView!
    private var airQualityView: AirQualityView!
    
    private let scrol = UIScrollView()
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        print("BundleView init 🖼️ ✅")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("BundleView deinit 🖼️ ❌")
    }
    
    
    //MARK: - SetupUI
    /// Создаёт и добавляет subviews на BundleView используя указанные responce
    public func setupUI(forGeo geo: GeoResponce, using weatherResponce: OpenWeatherResponce, _ airQualityResponce: OpenWeatherAirPollutionResponce) {
        /// Создаём объекты для создания view используя переданный responce
        let mainInfoViewDataModel = TemperatureViewDataModel(openWeatherResponce: weatherResponce)
        let sunriseSunsetViewDataModel = SunriseSunsetViewDataModel(openWeatherResponce: weatherResponce)
        let airQualityViewDataModel = AirQualityViewDataModel(openWeatherResponce: airQualityResponce)
        
        /// Создаем view
        configureCityNameLabel(withGeo: geo)
        createTemperatureView(with: TemperatureViewDataModel(openWeatherResponce: weatherResponce))
        configureSunriseSunsetView(withModel: sunriseSunsetViewDataModel)
        configureAirQualityView(withModel: airQualityViewDataModel)
    }
   
    
    // MARK: - Create and Configure Views
    private func configureCityNameLabel(withGeo geo: GeoResponce) {
        self.addSubview(cityNameLabel)
        cityNameLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityNameLabel.topAnchor.constraint(equalTo: self.topAnchor),
            cityNameLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            cityNameLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            cityNameLabel.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.06)
        ])
        
        cityNameLabel.font = UIFont.systemFont(ofSize: 30)
        cityNameLabel.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        cityNameLabel.textAlignment = .center
        cityNameLabel.text = geo.nameOfLocation ?? "☹️"
        
        // рисуем границу view
//        cityNameLabel.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
//        cityNameLabel.layer.borderWidth = 0.5
    }
    
    private func createTemperatureView(with model: TemperatureViewDataModel) {
        temperatureView = TemperatureView(model)
        guard let view = temperatureView else { return }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
        
        // рисуем границу view
//        self.layer.borderColor = #colorLiteral(red: 0.5725490451, green: 0, blue: 0.2313725501, alpha: 1)
//        self.layer.borderWidth = 0.5
    }
    
    private func configureSunriseSunsetView(withModel model: SunriseSunsetViewDataModel) {
        sunriseSunsetView = SunriseSunsetView(model)
        guard let view = sunriseSunsetView else { return }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: temperatureView!.bottomAnchor, constant: 10),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func configureAirQualityView(withModel model: AirQualityViewDataModel) {
        airQualityView = AirQualityView(dataModel: model)
        guard let view = airQualityView else { return }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: sunriseSunsetView!.bottomAnchor, constant: 10),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.24),
            view.widthAnchor.constraint(equalTo: view.heightAnchor)
        ])
    }
}
