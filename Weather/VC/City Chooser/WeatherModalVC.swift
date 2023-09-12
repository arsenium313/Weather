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
    private let notificationCenter = NotificationCenter.default
    /// Нужен для доступа к PageVC, забора массивов [GeoResponces] и [WeatherResponces]
    private let cityChoserVC: CityChooserVC
    /// Нужен для сохранения в CD, и отправке Notification
    private var geoResponce: GeoResponce
    /// Нужен для добавления в массив pages на PageVC
    private var weatherResponce: (OpenWeatherResponce, OpenWeatherAirPollutionResponce)?
    
    
    // MARK: - Init
    /**
     - Parameter geoResponce: Координаты города погоду которого нужно найти
     - Parameter cityChoserVC : Предыдущий экран
     */
    init(geoResponce geo: GeoResponce, cityChoserVC: CityChooserVC) {
        print("WeatherModalVC Init ✅")
        self.geoResponce = geo
        self.cityChoserVC = cityChoserVC
        super.init(nibName: nil, bundle: nil)
        
        networkManager.downloadWeatherCondition(for: geo) {
            self.bundleView.setupUI(forGeo: geo, using: $0.0, $0.1)
            self.weatherResponce = $0
        }
    } 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WeatherModalVC deinit ❌")
    }
    
    
    //MARK: - View Life Circle
    override func loadView() {
        let view = GradientRootView()
        self.view = view
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureBundleView()
    }
    
    private func configureSelf() {
        navigationItem.rightBarButtonItem = addBarButton
    }
    
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

        
    // MARK: - UIBarButtonItem Creation and Configuration
    private var addBarButton: UIBarButtonItem {
        let image = UIImage(systemName: "square.and.arrow.down")
        let button = UIBarButtonItem(image: image, style: .plain,
                                     target: self,
                         action: #selector(barButtonItemClicked(_:)))
        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return button
    }

    
    // MARK: - @objc
    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        /// Создаём элемент в CD
        let index = cityChoserVC.tableView.numberOfRows(inSection: 0)
        DataManager.shared.createGeoEntity(geo: geoResponce, index: index)
        
        /// Добавляем WeatherHomeVC в PageVC
        guard let pageVC = cityChoserVC.navigationController?.viewControllers[0] as? PageVC,
        let weatherResponce = weatherResponce else { return }
        pageVC.appendPage(geo: geoResponce, weatherResponce: weatherResponce)
        
        /// Отправляем Notification
        var geoResponces = cityChoserVC.geoResponces
        geoResponces.append(geoResponce)
        var weatherResponces = cityChoserVC.weatherResponces
        weatherResponces.append(weatherResponce)
        
        let geoDictionary: [String : [GeoResponce]] = ["geo" : geoResponces]
        notificationCenter.post(name: .addGeoResponce, object: self, userInfo: geoDictionary)
        
        let weatherDictionary: [String : [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]]
        = ["weather" : weatherResponces]
        self.notificationCenter.post(name: .addWeatherResponce, object: self,
                                     userInfo: weatherDictionary)
        
        cityChoserVC.searchController.isActive = false
        dismiss(animated: true)
    }
}
