//
//  PageVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.09.2023.
//

import UIKit

class PageVC: UIPageViewController {

    // MARK: Properties
    public var pages: [WeatherHomeVC] = []
   
    private let networkManager = NetworkManager()
    private let notificationCenter = NotificationCenter.default
    private let pageControl = UIPageControl()
    // Чтобы не выскакивала ошибка в консоль нужно вручную указывать высоту
    private let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0,
                                                  width: UIScreen.main.bounds.width, height: 45))
    private var initialPage = 0
    private var geoResponces: [GeoResponce] = []
    private var weatherResponces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = []
    /// Инициализируем здесь чтобы при notification информация уже пришла в cityChooserVC
    private var cityChooserVC = CityChooserVC()
    

    // MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    // MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureToolBar()
        configurePageControl()
    }

    private func configureSelf() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = #colorLiteral(red: 0.1991047561, green: 0.2040857375, blue: 0.2466743588, alpha: 1)
        dataSource = self
        delegate = self
    
        notificationCenter.addObserver(self, selector: #selector(reseveNotification(_:)),
                                       name: .addGeoResponce, object: nil)
       
        DataManager.shared.fetchSavedCities() { geoResponces in
            let geoDictionary: [String : [GeoResponce]] = ["geo" : geoResponces]
            notificationCenter.post(name: .addGeoResponce, object: self, userInfo: geoDictionary)
            findInitialPageIndex()
        }
    
        networkManager.downloadWeatherConditionArray(for: geoResponces) { [self] weatherResponces  in
            // Создаешь тут массив pages сразу инициализировав с responce 
//            fillPagesArray()
//            for (i, weatherHomeVC) in pages.enumerated() {
//                let geo = self.geoResponces[i]
////                weatherHomeVC.bundleView.setupUI(forGeo: geo, using: weatherResponces[i].0,
////                                                 weatherResponces[i].1)
//            }
            
            for (i, weatherResponce) in weatherResponces.enumerated() {
                let vc = WeatherHomeVC(geoResponce: geoResponces[i],
                                       weatherResponce: weatherResponce.0,
                                       airPollutionResponce: weatherResponce.1)
                pages.append(vc)
            }
            
            
            setViewControllers([pages[initialPage]], direction: .forward, animated: false)
            /// Отправляем Notification
            let weatherDictionary: [String : [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]]
            = ["weather" : weatherResponces]
            self.notificationCenter.post(name: .addWeatherResponce, object: self,
                                         userInfo: weatherDictionary)
        }
        
    }
    
    private func configurePageControl() {
        pageControl.isEnabled = false
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = initialPage
        
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor),
            pageControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor)
        ])
    }
    
    private func configureToolBar() {
        toolBar.barTintColor = #colorLiteral(red: 0.1991047561, green: 0.2040857375, blue: 0.2466743588, alpha: 1)
        toolBar.isTranslucent = false
        toolBar.items = [flexibleSpaceBarButtonItem, listBarButtonItem]
        self.view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            // Чтобы не выскакивала ошибка в консоль нужно вручную указывать высоту
            toolBar.heightAnchor.constraint(equalToConstant: 45)
        ])
        
    }
    
    
    // MARK: - Update Pages Array
    /// Создаём WeatherHomeVC, настраиваем его bundleView и кладем в массив pages
    public func appendPage(geo: GeoResponce, weatherResponce tuple:
                           (OpenWeatherResponce, OpenWeatherAirPollutionResponce)) {
        let weatherVC = WeatherHomeVC(geoResponce: geo,
                                      weatherResponce: tuple.0,
                                      airPollutionResponce: tuple.1)
    //    weatherVC.bundleView.setupUI(forGeo: geo, using: tuple.0, tuple.1)
        self.pages.append(weatherVC)
    }
    
    /// Создаём WeatherHomeVC в количестве сохранённых в CD городов, и помещаем их в массив pages
    private func fillPagesArray() {
//        guard !geoResponces.isEmpty else { return }
//        for _ in 0...geoResponces.count - 1 {
//            let vc = WeatherHomeVC()
//            self.pages.append(vc)
//        }
    }
    

    // MARK: - Find Initial Page
    /// Ищет isFirstToShow и устанавливает initialPage, Если не нашло, то ничего не делает и initialPage остаётся = 0
    private func findInitialPageIndex() {
        if let firstGeo = DataManager.shared.fetchFirstToShow() {
            self.initialPage = self.geoResponces.firstIndex(where: {
                $0.lat == firstGeo.lat && $0.lon == firstGeo.lon }) ?? 0
        }
    }
    
    /// Обновляет CurrentPage для указанного индекса
    public func updatePageControlCurrentPage(to index: Int) {
        let number = pageControl.numberOfPages
        pageControl.numberOfPages = 0
        pageControl.numberOfPages = number
        pageControl.currentPage = index
    }
    
    
    // MARK: - UIBarButtonItem Creation and Configuration
    private var flexibleSpaceBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    
    private var listBarButtonItem: UIBarButtonItem {
        let image = UIImage(systemName: "list.bullet")
        let button =  UIBarButtonItem(image: image, style: .done, target: self,
                               action: #selector(barButtonItemClicked(_:)))
        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return button
    }
    
    
    // MARK: - @objc
    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(cityChooserVC, animated: true)
    }
    
    @objc
    private func reseveNotification(_ sender: Notification) {
        switch sender.name {
        case .addGeoResponce:
            guard let geo = sender.userInfo?["geo"] as? [GeoResponce] else { return }
            self.geoResponces = geo
            self.pageControl.numberOfPages = geo.count
        default: return
        }
    }
    
}


// MARK: - UIPageVC Data Source
extension PageVC: UIPageViewControllerDataSource {
    /// Устанавливаем предыдущие VC
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController)
    -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! WeatherHomeVC)
        else { return nil }
        
        if currentIndex == 0 { // Если экран самый левый, по кругу не возвращаемся
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    /// Устанавливаем следующие VC
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! WeatherHomeVC)
        else { return nil }
        
        if currentIndex < pages.count - 1 { // count считается с 1, а index c 0
            return pages[currentIndex + 1]
        } else {
            return nil
        }
    }
    
}


// MARK: - UIPageVC Delegate
extension PageVC: UIPageViewControllerDelegate {
    /// Обновляем необходимое после свайпов экранов WeatherHomeVC
    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0] as! WeatherHomeVC)
        else { return }
        
        pageControl.currentPage = currentIndex
        DataManager.shared.setIsFirstToShowFlag(geo: geoResponces[currentIndex])
    }
}
