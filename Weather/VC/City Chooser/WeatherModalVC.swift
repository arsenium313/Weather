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
    private let cityChoserVC: CityChooserVC // нужен для обновления таблицы, добавления элементов в массивы
    private var geoResponceToSave: GeoResponce // чтоб сохранить его в UD или CoreData
    private var weatherConditionTuple: (OpenWeatherResponce, OpenWeatherAirPollutionResponce)! // разобраться с опционалом
    
    
    // MARK: - Init
    /**
     - Parameter geoResponce: Координаты города погоду которого нужно найти
     - Parameter cityChoserVC : Предыдущий экран, нужен здесь для обновления его таблицы (экран в своем Navigation stack)
     */
    init(geoResponce geo: GeoResponce, cityChoserVC: CityChooserVC) {
        print("WeatherModalVC Init 🧐")
        self.geoResponceToSave = geo
        self.cityChoserVC = cityChoserVC
        super.init(nibName: nil, bundle: nil)
        
        networkManager.downloadWeatherCondition(for: geo) {
            self.bundleView.setupUI(forGeo: geo, using: $0.0, $0.1)
            self.weatherConditionTuple = $0
        }
    } 
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WeatherModalVC deinit 🧐")
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
        configureBundleView()
        configureAddCityBarButton()
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
    
    private func configureAddCityBarButton() {
        navigationController?.navigationBar.titleTextAttributes =
        [NSAttributedString.Key.foregroundColor : UIColor.white]
        self.navigationItem.rightBarButtonItem = addBarButton
        addBarButton.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
        
    
    // MARK: - UIBarButtonItem Creation and Configuration
    private var addBarButton: UIBarButtonItem {
        let image = UIImage(systemName: "square.and.arrow.down")
        return UIBarButtonItem(image: image, style: .plain,
                                           target: self,
                               action: #selector(barButtonItemClicked(_:)))
    }

    
    // MARK: - @objc
    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        print("barButtonItemClicked 🧐")
        DataManager.shared.createGeoEntity(geo: geoResponceToSave)
        
        cityChoserVC.geoResponces.append(geoResponceToSave)
        cityChoserVC.weatherResponceTuples?.append(weatherConditionTuple)
        
        cityChoserVC.tableView.reloadData()
        cityChoserVC.searchController.isActive = false
        
        /// Создаём WeatherHomeVC и кладем его в массив в PageVC
        /// PageVC это rootVC, поэтому всегда будет под 0 индексом
        if let pageVC = cityChoserVC.navigationController?.viewControllers[0] as? PageVC {
            print("Удалось привести к PageVC 🧐")
            let weatherHomeVC = WeatherHomeVC()

            weatherHomeVC.bundleView.setupUI(forGeo: geoResponceToSave,
                                             using: weatherConditionTuple.0, weatherConditionTuple.1)
            pageVC.pages.append(weatherHomeVC)
            pageVC.changePageControlPageAmount { $0.numberOfPages += 1 }
  
        } else {
            print("Не удалось привести к PageVC 😨")
        }
        
        dismiss(animated: true)
    }
}
