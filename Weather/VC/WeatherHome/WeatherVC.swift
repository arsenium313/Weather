//
//  ViewController.swift
//  Weather
//
//  Created by Арсений Кухарев on 05.07.2023.
//

import UIKit

class WeatherVC: UIViewController {

    //MARK: Properties
    private var mainInfoView: MainInfoView!
    private var sunriseSunsetView: SunriseSunsetView!
    private var airQualityView: AirQualityView!
    
    private var goToCityChooserButton: UIBarButtonItem!
    
    private lazy var guide = self.view.layoutMarginsGuide
    
    private let networkManager = NetworkManager()
    private var weatherResponce: OpenWeatherResponce!
    private var airQualityResponce: OpenWeatherAirPollutionResponce!
    private var geoResponce: GeoResponce!
    
    private var selfViewDidLoad = false
    
    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        // 1- ищу в persistance город по умолчанию, в persistance уже хранится объект coord
        let coor = Coordinates(lon: 31, lat: 52.26)
        
        networkManager.getWeather(for: coor) { responce in
            self.weatherResponce = responce
            DispatchQueue.main.async {
                // проверка если viewDidLoad выполнился, то запускаем setupUI()
                if self.selfViewDidLoad {
                    self.setupUIWhenGetOpenWeatherResponce(responce)
                } else {
                    print("☹️")
                    fatalError()
                }
            }
        }
        
        networkManager.getAirPollution(for: coor) { responce in
            DispatchQueue.main.async {
                if self.selfViewDidLoad {
                    self.setupUIWhenGetAqiResponce(responce)
                } else {
                    print("☹️")
                    fatalError()
                }
            }
        }
        
    }
    // разделить методы на
    // выполняются сразу
    // выполняются когда получили responce
    //   ВСЕ будет отображаться только после получения
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Life Circle
    override func loadView() {
        let view = RootView()
        self.view = view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selfViewDidLoad = true
        setupUI()
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureGoToChooserButtonItem()
        
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
    
    private func configureSelf() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = "Гомель"
    }
    
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
    
    
    private func configureGoToChooserButtonItem() {
        goToCityChooserButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCityChooserVC))
        self.navigationItem.rightBarButtonItem = goToCityChooserButton
    }
    
    //MARK: - Selectors
    @objc
    private func goToCityChooserVC() {
        let vc = CityChooserVC()
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Get weather and update UI
    private func getWeather(geo: GeoResponce) {
 
    }
    
    
}


//MARK: - Protocols
extension WeatherVC: CityChooserDelegate {
    /// Получаем информацию о геопозиции искомого города
    func passGeoResponce(_ geo: GeoResponce) { //принимаем информацию о геопозиции искомого города
        self.geoResponce = geo
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
            self.mainInfoView.removeFromSuperview()
            self.sunriseSunsetView.removeFromSuperview()
            self.setupUIWhenGetOpenWeatherResponce(self.weatherResponce)
            self.airQualityView.removeFromSuperview()
            self.setupUIWhenGetAqiResponce(self.airQualityResponce)
        }
    }
}





