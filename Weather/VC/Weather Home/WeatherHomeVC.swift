//
//  ViewController.swift
//  Weather
//
//  Created by Арсений Кухарев on 05.07.2023.
//

import UIKit

class WeatherHomeVC: UIViewController {

    //MARK: Properties
    private let bundleView = BundleView()
    private let networkManager = NetworkManager()
    private var cityChooserVC = CityChooserVC()
    
    var savedCities = PublicGeoArray.savedCities // В будущем из UserDefaults или CoreData
    
    
    //MARK: - Init
    /**
     - Parameter geoResponce: Координаты города который нужно найти
     */
    init(geoResponce geo: GeoResponce? = nil) {
        print("Weather VC Init")
        super.init(nibName: nil, bundle: nil)
        
        if let geo = geo { // Если передали с CityChoserVC
            let coordinates = Coordinates(lon: geo.lon, lat: geo.lat)
            downloadAndSetupUI(coordinates)
            self.navigationItem.title = geo.nameOfLocation
            
        } else if DataManager.shared.fetchSavedCities().count > 0 { // Сразу после запуска, если есть сохраненные значения в CD
            let savedCities = DataManager.shared.fetchSavedCities() // потом сделать предикат по флагу и только один вариант
            let first = savedCities.first
            let coordinates = Coordinates(lon: first?.lon ?? 0,
                                  lat: first?.lat ?? 0)
            downloadAndSetupUI(coordinates)
            self.navigationItem.title = first?.nameOfLocation ?? "nil"
            
        } else { // Сразу после запуска, если сохраненных городов нет
            self.navigationItem.title = "Нет городов"
        }
    }
        
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("Weather VC deinit")
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
    
    // Из-за разных фонов WeatherVC и CityChoserVC нужно вручную менять цвет акцента верхнего navigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureGoToCityChooserVCBarButton()
        configureBundleView()
    }
    
    private func configureSelf() {
        cityChooserVC.delegate = self
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
    
    
    // MARK: - Downloading
    private func downloadAndSetupUI(_ coordinates: Coordinates) {
        var weatherResponce: OpenWeatherResponce!
        var airQualityResponce: OpenWeatherAirPollutionResponce!
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        networkManager.getWeather(for: coordinates) { responce in
            weatherResponce = responce
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkManager.getAirPollution(for: coordinates) { responce in
            airQualityResponce = responce
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.bundleView.setupUI(using: weatherResponce, airQualityResponce)
        }
    }
    
    
    // MARK: - Configure Bar Buttons
    private func configureGoToCityChooserVCBarButton() {
        let image = UIImage(systemName: "list.bullet")
        let barButton = UIBarButtonItem(image: image, style: .plain, target: self,
                                        action: #selector(goToCityChooserVC))
        self.navigationItem.rightBarButtonItem = barButton
    }
        
    
    //MARK: - Selectors
    @objc
    private func goToCityChooserVC() {
        self.navigationController?.pushViewController(cityChooserVC, animated: true)
    }
}


//MARK: - Protocols
extension WeatherHomeVC: CityChooserDelegate {
    /// Получаем гео инфо из таблицы CityChoserVC, для отправки запроса
    func passGeoResponce(_ geo: GeoResponce) {
        self.title = geo.nameOfLocation
       
        let dispatchGroup = DispatchGroup()
        let coordinates = Coordinates(lon: geo.lon, lat: geo.lat)

        var weatherResponce: OpenWeatherResponce!
        var airQualityResponce: OpenWeatherAirPollutionResponce!
        
        dispatchGroup.enter()
        networkManager.getWeather(for: coordinates) { responce in
            weatherResponce = responce
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        networkManager.getAirPollution(for: coordinates) { responce in
            airQualityResponce = responce
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.bundleView.viewReset()
            self.bundleView.setupUI(using: weatherResponce, airQualityResponce)
        }
    }
}





