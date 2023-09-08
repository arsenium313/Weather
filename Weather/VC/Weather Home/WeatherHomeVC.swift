//
//  ViewController.swift
//  Weather
//
//  Created by Арсений Кухарев on 05.07.2023.
//

import UIKit

class WeatherHomeVC: UIViewController {

    //MARK: Properties
    public let bundleView = BundleView()
    private let networkManager = NetworkManager() // не нужно будет, этот экран ничего не загружает
 //   private var cityChooserVC = CityChooserVC()
    
    
    //MARK: - Init
    init() {
        print("Weather VC Init")
        super.init(nibName: nil, bundle: nil)
        
        // Сразу после запуска, если есть сохраненные значения в CD
        
        // что показываать больше не его дело вообще, а дело pageVC, он только должен принять в инит респонс и нарисоваться
        
//        if DataManager.shared.fetchSavedCities().count > 0 {
//            let geo = DataManager.shared.fetchFirstToShow()
//            networkManager.downloadWeatherCondition(for: geo) {
//                self.bundleView.setupUI(using: $0.0, $0.1)
//            }
//            self.navigationItem.title = geo.nameOfLocation ?? "nil"
//
//            // Сразу после запуска, если сохраненных городов нет
//        } else { // не нужно будет в итоге
//            self.navigationItem.title = "Нет городов"
//        }
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
       // cityChooserVC.delegate = self
        modalPresentationStyle = .fullScreen
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
       
//        let barButton = UIBarButtonItem(image: image, style: .plain, target: self,
//                                        action: #selector(goToCityChooserVC))
//        self.navigationItem.rightBarButtonItem = barButton
    }
        
    
    //MARK: - Selectors
    @objc
    private func goToCityChooserVC() {
       // self.navigationController?.pushViewController(cityChooserVC, animated: true)
    }
}


//MARK: - Protocols
extension WeatherHomeVC: CityChooserDelegate { // не нужно будет, все уже будут загружени и при нажатии в таблице переходить а уже готовый
    /// Обновляем bundleView  из указанных pesponce и обновляем title из указанного GeoResponce
    func passResponces(_ geo: GeoResponce, responceTuple: (OpenWeatherResponce, OpenWeatherAirPollutionResponce)) {
        self.bundleView.viewReset()
        self.title = geo.nameOfLocation
       // self.bundleView.setupUI(using: responceTuple.0, responceTuple.1)
    }

}





