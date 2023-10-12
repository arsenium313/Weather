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
  //  private let cityChoserVC: CityChooserVC
    /// Нужен для сохранения в CD, и отправке Notification
    private var geoResponce: GeoResponce
    /// Нужен для добавления в массив pages на PageVC
    private var weatherResponce: (OpenWeatherResponce, OpenWeatherAirPollutionResponce)?
    
    private let index: Int
    
    // MARK: - Init
    /**
     - Parameter geoResponce: Координаты города погоду которого нужно найти
     - Parameter cityChoserVC : Предыдущий экран
     */
    init(geoResponce geo: GeoResponce, tableCount index: Int) { // не cityChooser принимать, а индекс для CD entity
        print("WeatherModalVC Init ✅")
        self.index = index
        self.geoResponce = geo
        //self.cityChoserVC = cityChoserVC
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

    /**
     для инициализации передаем geo и ищем в интернете данные
     */
    
    /**
     При нажатии кнопки "Добавить"
     1. Создаём элемент geo в CD
     
     Отправляем информацию в CityChooser
     - добавляем geo в массив - единичный нотификация
     - добавляем openWeatherResponce в массив -  новая единичная нотификаяция
     
     
     
     Отправляем информацию в PageVC
     - добавляем geo в массив - единичный нотификация
     - создаем weatherVC и добавляем его в массив pages - пока вопрос ?
     
     
     
     10. Убираем активную поисковую строку из предыдущего экрана
     11. dismiss этот экран
     */
    
    // MARK: - @objc
    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        //1
        /// Создаём элемент в CD
        DataManager.shared.createGeoEntity(geo: geoResponce, 
                                           index: index)
        
        guard let weatherResponce = weatherResponce else {
            dismiss(animated: true)
            return
        }
        
        /// Принимает:
        /// - CityChooserVC
        /// - PageVC
        notificationCenter.post(name: .singleGeo,
                                object: self,
                                userInfo: [NSNotification.keyName : geoResponce])
        
        /// Принимает:
        /// - CityChooserVC
        notificationCenter.post(name: .singleWeather,
                                object: self,
                                userInfo: [NSNotification.keyName : weatherResponce.0])
       
        /// Принимает:
        /// - PageVC
        notificationCenter.post(name: .weatherTuple,
                                object: self,
                                userInfo: [NSNotification.keyName : (geoResponce,
                                                                     weatherResponce.0,
                                                                     weatherResponce.1)])
    
        dismiss(animated: true)
    }
}
