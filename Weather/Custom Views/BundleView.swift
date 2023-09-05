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
    private var mainInfoView: MainInfoView?
    private var sunriseSunsetView: SunriseSunsetView?
    private var airQualityView: AirQualityView?
    
    
    // MARK: - Init
    init() {
        super.init(frame: .zero)
        print("Bundle Weather View init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Bundle Weather View deinit")
    }
    
    
    //MARK: - SetupUI
    /// Убирает все subview с BundleView, и делает subview nil
    public func viewReset() {
        mainInfoView?.removeFromSuperview()
        sunriseSunsetView?.removeFromSuperview()
        airQualityView?.removeFromSuperview()
        
        mainInfoView = nil
        sunriseSunsetView = nil
        airQualityView = nil
    }
    
    /// Создаёт и добавляет subviews на BundleView используя указанные responce
    public func setupUI(using weatherResponce: OpenWeatherResponce, _ airQualityResponce: OpenWeatherAirPollutionResponce) {
        // Создаём объекты для создания view используя переданный responce
        let mainInfoViewDataModel = MainInfoViewDataModel(openWeatherResponce: weatherResponce)
        let sunriseSunsetViewDataModel = SunriseSunsetViewDataModel(openWeatherResponce: weatherResponce)
        let airQualityViewDataModel = AirQualityViewDataModel(openWeatherResponce: airQualityResponce)
        
        // создаем view
        configureMainInfoView(withModel: mainInfoViewDataModel)
        configureSunriseSunsetView(withModel: sunriseSunsetViewDataModel)
        configureAirQualityView(withModel: airQualityViewDataModel)
    }
   
    
    // MARK: - Create and Configure Views
    private func configureMainInfoView(withModel model: MainInfoViewDataModel) {
        mainInfoView = MainInfoView(model)
        guard let view = mainInfoView else { return }
        self.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
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
            view.topAnchor.constraint(equalTo: mainInfoView!.bottomAnchor, constant: 10),
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