//
//  ViewController.swift
//  Weather
//
//  Created by Арсений Кухарев on 05.07.2023.
//

import UIKit

class WeatherVC: UIViewController {

    //MARK: Properties
    // Views
    private var mainInfoView: MainInfoView!
    private var sunriseSunsetView: SunriseSunsetView!
    private var airQualityView: AirQualityView!
    // Responces
    private let networkManager = NetworkManager()
    private var weatherResponce: OpenWeatherResponce!
    private var airQualityResponce: OpenWeatherAirPollutionResponce!
    // Other
    public var addCityInUserDefaultsBarButton: UIBarButtonItem!
    private var goToCityChooserBarButton: UIBarButtonItem!
    private var isPresentedFromSearchVC: Bool
    
    private var cityChooserVC = CityChooserVC()
    
    private lazy var guide = self.view.layoutMarginsGuide
    
    var savedCities = PublicGeoArray.savedCities
    
    
    //MARK: - Init
    /**
     - Parameter geoResponce: Координаты города который нужно найти
     - Parameter isPresentedFromSearchVC: От параметра зависит какая кнопка будет в rightBarButtonItem
     */
    init(geoResponce: GeoResponce? = nil, isPresentedFromSearchVC: Bool = false) {
        print("Weather VC Init")
        self.isPresentedFromSearchVC = isPresentedFromSearchVC
        super.init(nibName: nil, bundle: nil)
        var coordinates: Coordinates!
        let myGroup = DispatchGroup()
        
        // Если не передали координаты в инициализатор, то из UserDefaults берет первый в списке город
        if let geoResponce = geoResponce {
            coordinates = Coordinates(lon: geoResponce.lon,
                                      lat: geoResponce.lat)
            self.navigationItem.title = geoResponce.nameOfLocation
        } else {
            coordinates = Coordinates(lon: savedCities.first?.lon ?? 0,
                                  lat: savedCities.first?.lat ?? 0)
            self.navigationItem.title = savedCities.first?.nameOfLocation ?? "nil"
        }
        
        myGroup.enter()
        networkManager.getWeather(for: coordinates) { responce in
            self.weatherResponce = responce
            myGroup.leave()
        }
        
        myGroup.enter()
        networkManager.getAirPollution(for: coordinates) { responce in
            self.airQualityResponce = responce
            myGroup.leave()
        }
        
        myGroup.notify(queue: .main) { [self] in
            setupUIWhenGetOpenWeatherResponce(weatherResponce)
            setupUIWhenGetAqiResponce(airQualityResponce)
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
        let view = RootView()
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
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        
        if isPresentedFromSearchVC {
            configureAddCityInUserDefaultsBarButton()
        } else {
            configureGoToChooserBarButton()
        }
    }
    
    private func configureSelf() {
        cityChooserVC.delegate = self
    }
    
    private func setupUIWhenGetOpenWeatherResponce(_ responce: OpenWeatherResponce) {
        let mainInfoResponce = MainInfoViewDataModel(responce: responce)
        let sunriseSunsetResponce = SunriseSunsetViewDataModel(weatherResponce: responce)
        configureMainInfoView(mainInfoResponce)
        configureSunriseSunsetView(sunriseSunsetResponce)
    }
    
    private func setupUIWhenGetAqiResponce(_ responce: OpenWeatherAirPollutionResponce) {
        let aqiResponce = AirQualityViewDataModel(responce: responce)
        configureAirQualityView(aqiResponce)
    }
    
  
    //MARK: Configure Views
    private func configureMainInfoView(_ responce: MainInfoViewProtocol) {
        mainInfoView = MainInfoView(responce)
        self.view.addSubview(mainInfoView)
        mainInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainInfoView.topAnchor.constraint(equalTo: guide.topAnchor),
            mainInfoView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            mainInfoView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            mainInfoView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.3)
        ])
    }
   
    private func configureSunriseSunsetView(_ responce: SunriseSunsetViewProtocol) {
        sunriseSunsetView = SunriseSunsetView(responce)
        self.view.addSubview(sunriseSunsetView)
        sunriseSunsetView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            sunriseSunsetView.topAnchor.constraint(equalTo: mainInfoView.bottomAnchor, constant: 20),
            sunriseSunsetView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            sunriseSunsetView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            sunriseSunsetView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.3)
        ])
    }
    
    private func configureAirQualityView(_ responce: AirQualityViewDataModel) {
        airQualityView = AirQualityView(responce: responce)
        self.view.addSubview(airQualityView)
        airQualityView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            airQualityView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            airQualityView.topAnchor.constraint(equalTo: sunriseSunsetView.bottomAnchor, constant: 20),
            airQualityView.heightAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.48),
            airQualityView.heightAnchor.constraint(equalTo: airQualityView.widthAnchor)
        ])
    }
    
    //MARK: Configure Bar Buttons
    private func configureGoToChooserBarButton() {
        goToCityChooserBarButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCityChooserVC))
        self.navigationItem.rightBarButtonItem = goToCityChooserBarButton
    }
    
    private func configureAddCityInUserDefaultsBarButton() {
//        addCityInUserDefaultsButton = UIBarButtonItem(title: "Добавить", style: .plain, target: self, action: #selector(addCityInUserDefaults))
//        self.navigationItem.rightBarButtonItem = addCityInUserDefaultsButton
        addCityInUserDefaultsBarButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(addCityInUserDefaultsBarButtonAction))
        navigationItem.rightBarButtonItem = addCityInUserDefaultsBarButton
        
    }
    
    //MARK: - Selectors
    @objc
    private func goToCityChooserVC() {
        self.navigationController?.pushViewController(cityChooserVC, animated: true)
    }

    @objc
    private func addCityInUserDefaultsBarButtonAction() {
     //   cityChooserVC.searchController.isActive = false
//        PublicGeoArray.savedCities.append(geoResponceToSave!)
//        navigationController?.dismiss(animated: true)
        // переход на CityChoser
      
       // navigationController?.pushViewController(vc, animated: true)
      //  navigationController?.popToRootViewController(animated: true)
        print("Test")
       // PublicGeoArray.savedCities.append(geoResponceToShare)
        cityChooserVC.tableView.reloadData()
        cityChooserVC.searchController.isActive = false
        cityChooserVC.resultsTableVC?.navigationVC.dismiss(animated: true)
       // navigationVC?.dismiss(animated: true)
        
        
        
    }
}


//MARK: - Protocols
extension WeatherVC: CityChooserDelegate {
    /// Получаем информацию о геопозиции города из таблицы сохраненных, для отправки запроса
    func passGeoResponce(_ geo: GeoResponce) { //принимаем информацию о геопозиции искомого города
        self.title = geo.nameOfLocation
        let myGroup = DispatchGroup()
        
        myGroup.enter()
        networkManager.getWeather(for: Coordinates(lon: geo.lon, lat: geo.lat)) { weatherResponce in
            self.weatherResponce = weatherResponce
            myGroup.leave()
        }
        
        myGroup.enter()
        networkManager.getAirPollution(for: Coordinates(lon: geo.lon, lat: geo.lat)) { weatherResponce in
            self.airQualityResponce = weatherResponce
            myGroup.leave()
        }
        
        myGroup.notify(queue: .main) {
            print("passGeo")
            self.mainInfoView.removeFromSuperview()
            self.sunriseSunsetView.removeFromSuperview()
            self.setupUIWhenGetOpenWeatherResponce(self.weatherResponce)
            self.airQualityView.removeFromSuperview()
            self.setupUIWhenGetAqiResponce(self.airQualityResponce)
        }
    }
}





