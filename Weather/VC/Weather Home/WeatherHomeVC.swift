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
        
        // надо поменять чтобы при инициализации принимать уже готовый респонс
        
        
        // Если передали с CityChoserVC
        if let geo = geo {
            let coordinates = Coordinates(lon: geo.lon, lat: geo.lat)
            networkManager.downloadAndSetupUI(coordinates, forView: bundleView)
            self.navigationItem.title = geo.nameOfLocation
            
            // Сразу после запуска, если есть сохраненные значения в CD
        } else if DataManager.shared.fetchSavedCities().count > 0 {
            let geo = DataManager.shared.fetchFirstToShow()
            let coordinates = Coordinates(lon: geo.lon, lat: geo.lat)
            networkManager.downloadAndSetupUI(coordinates, forView: bundleView)
            self.navigationItem.title = geo.nameOfLocation ?? "nil"
            
            // Сразу после запуска, если сохраненных городов нет
        } else {
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
    /// Обновляем bundleView  из указанного GeoResponce
    func passGeoResponce(_ geo: GeoResponce) {
        self.bundleView.viewReset()
        self.title = geo.nameOfLocation
        let coordinates = Coordinates(lon: geo.lon, lat: geo.lat)
        networkManager.downloadAndSetupUI(coordinates, forView: bundleView)
    }
}





