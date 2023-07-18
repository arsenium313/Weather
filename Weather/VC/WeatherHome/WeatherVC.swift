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
    private var sunriseSunsetView: SunriseSunset!
    
    private var goToCityChooserButton: UIBarButtonItem!
    
    private lazy var guide = self.view.layoutMarginsGuide
    
    private let networkManager = NetworkManager()
    private var weatherResponce: WeatherResponce!
    private var geoResponce: GeoResponce!
    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        let coor = Coordinates(lon: 32, lat: 51)
        networkManager.getWeather(for: coor) { responce in
            self.weatherResponce = responce
            DispatchQueue.main.async {
                let newResponce = MainInfoForViewStruct(responce: responce)
                self.mainInfoView.setupUI(weatherResponce: newResponce)
            }
        }
    }
    
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
        setupUI()
        configureMainInfoView()
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureMainInfoView()
        configureGoToChooserButtonItem()
    }
    
    private func configureSelf() {
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = "Weather"
    }
    
    private func configureMainInfoView() {
        mainInfoView = MainInfoView()
        self.view.addSubview(mainInfoView)
        mainInfoView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainInfoView.topAnchor.constraint(equalTo: guide.topAnchor),
            mainInfoView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            mainInfoView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            mainInfoView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.3)
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
        networkManager.getWeather(for: Coordinates(lon: geo.lon, lat: geo.lat)) { weatherResponce in
            DispatchQueue.main.async {
                self.weatherResponce = weatherResponce
            }
            DispatchQueue.global(qos: .userInitiated).async {
                
            }
        }
    }
}





