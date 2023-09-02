//
//  WeatherModalVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 01.09.2023.
//

import UIKit

/// Создается и показывается когда в ResultsTable нажимаем на ряд, deinit автоматически когда пропадает с экрана
class WeatherModalVC: UIViewController {

    //MARK: Properties
    private let bundleView = BundleView()
    private let networkManager = NetworkManager()
    private let cityChoserVC: CityChooserVC
    private var geoResponceToSave: GeoResponce // чтоб сохранить его в UD или CoreData
    
    
    // MARK: - Init
    /**
     - Parameter geoResponce: Координаты города который нужно найти
     - Parameter cityChoserVC: Предыдущий экран, нужен здесь для обновления его таблицы (этот экран в своем Navigation stack)
     */
    init(geoResponce geo: GeoResponce, cityChoserVC: CityChooserVC) {
        print("WeatherModalVC Init")
        self.geoResponceToSave = geo
        self.cityChoserVC = cityChoserVC
        super.init(nibName: nil, bundle: nil)
        
        self.navigationItem.title = geo.nameOfLocation

        let coordinates = Coordinates(lon: geo.lon, lat: geo.lat)
        let dispatchGroup = DispatchGroup()
        
        var openWeatherResponce: OpenWeatherResponce!
        var openWeatherAirPollutionResponce: OpenWeatherAirPollutionResponce!
        
        dispatchGroup.enter()
        networkManager.getWeather(for: coordinates) { responce in
            openWeatherResponce = responce
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkManager.getAirPollution(for: coordinates) { responce in
            openWeatherAirPollutionResponce = responce
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.bundleView.setupUI(using: openWeatherResponce, openWeatherAirPollutionResponce)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WeatherModalVC deinit")
    }
    
    
    //MARK: - View Life Circle
    override func loadView() {
        let view = GradientRootView()
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureAddCityBarButton()
        configureBundleView()
    }

    //MARK: - SetupUI
    private func configureBundleView() {
        self.view.addSubview(bundleView)
        bundleView.translatesAutoresizingMaskIntoConstraints = false
        let guide = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            bundleView.topAnchor.constraint(equalTo: guide.topAnchor),
            bundleView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            bundleView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            bundleView.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }
    
    private func configureAddCityBarButton() {
        let barButton = UIBarButtonItem(title: "Add", style: .done,
                                           target: self,
                                           action: #selector(addCityBarButtonAction))
        self.navigationItem.rightBarButtonItem = barButton
    }
    
    // MARK: - @objc
    @objc
    private func addCityBarButtonAction() {
        DataManager.shared.createGeoEntity(geo: geoResponceToSave)
        cityChoserVC.updateSavedCiries()
        cityChoserVC.tableView.reloadData()
        cityChoserVC.searchController.isActive = false
        dismiss(animated: true)
    }
}
