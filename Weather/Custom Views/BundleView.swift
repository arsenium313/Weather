//
//  MainWeatherView.swift
//  Weather
//
//  Created by Арсений Кухарев on 01.09.2023.
//

import UIKit

/// Содержит subviews с погодой
class BundleView: UIView {
    
    // MARK: Properties
    // опционалы потомучто экран может быть загружен пустым, может вынести в опционал сам dundleVIew???
    private var cityNameLabel: UILabel?
    private var temperatureView: TemperatureView?
    private var sunriseSunsetView: SunriseSunsetView?
    private var airQualityView: AirQualityView?
    
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        print("BundleView init 🖼️✅")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("BundleView deinit 🖼️❌")
    }
    
    
    //MARK: - SetupUI
//    /// Убирает все subview с BundleView, и делает subview nil
//    public func viewReset() { // а нужно ли будет это в итоге?
//        cityNameLabel?.removeFromSuperview()
//        temperatureView?.removeFromSuperview()
//        sunriseSunsetView?.removeFromSuperview()
//        airQualityView?.removeFromSuperview()
//
//        cityNameLabel = nil
//        temperatureView = nil
//        sunriseSunsetView = nil
//        airQualityView = nil
//    }
    
    /// Создаёт и добавляет subviews на BundleView используя указанные responce
    public func setupUI(forGeo geo: GeoResponce, using weatherResponce: OpenWeatherResponce, _ airQualityResponce: OpenWeatherAirPollutionResponce) {
        /// Создаём объекты для создания view используя переданный responce
        let mainInfoViewDataModel = TemperatureViewDataModel(openWeatherResponce: weatherResponce)
        let sunriseSunsetViewDataModel = SunriseSunsetViewDataModel(openWeatherResponce: weatherResponce)
        let airQualityViewDataModel = AirQualityViewDataModel(openWeatherResponce: airQualityResponce)
        
        /// Создаем view
        configureCityNameLabel(withGeo: geo)
        configureTemperatureView(withModel: mainInfoViewDataModel)
        configureSunriseSunsetView(withModel: sunriseSunsetViewDataModel)
        configureAirQualityView(withModel: airQualityViewDataModel)
    }
   
    
    // MARK: - Create and Configure Views
    private func configureCityNameLabel(withGeo geo: GeoResponce) {
        cityNameLabel = UILabel()
        guard let label = cityNameLabel else { return }
        self.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.trailingAnchor),
          //  label.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.15)
        ])
        
        label.layer.borderColor = #colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        label.layer.borderWidth = 0.5
        label.text = geo.nameOfLocation ?? "☹️"
    }
    
    private func configureTemperatureView(withModel model: TemperatureViewDataModel) {
        temperatureView = TemperatureView(model)
        guard let view = temperatureView else { return }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: cityNameLabel!.bottomAnchor), //________________
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: 0.3)
        ])
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
