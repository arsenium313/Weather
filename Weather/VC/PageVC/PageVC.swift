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
    internal let notificationCenter = NotificationCenter.default
    
    internal let pageControl = UIPageControl()
    
    /// Чтобы не выскакивала ошибка в консоль, нужно вручную указывать CGSize toolBar при инициализации
    internal let toolBar = UIToolbar(frame: CGRect(origin: .zero,
                                                   size: CGSize(width: UIScreen.main.bounds.width,
                                                                height: 45)))
    internal var initialPage = 0
    internal var geoResponces: [GeoResponce] = []
    internal var weatherResponces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = []
    
    /// Инициализируем здесь чтобы при notification информация уже пришла в cityChooserVC
    internal var cityChooserVC = CityChooserVC()
    

    // MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    // MARK: - SetupUI
    private func setupUI() {
        layoutToolBar()
        layoutPageControl()
        
        configureNotification()
        addNotificationObserver()
        configureSelf()
        configureToolBar()
        configurePageControl()
        
    }

    private func configureSelf() {
        let color = UIColor.createGradientColor(in: self.view.bounds,
                                                for: [#colorLiteral(red: 0.2831242383, green: 0.2937351763, blue: 0.3573759198, alpha: 1).cgColor,
                                                      #colorLiteral(red: 0.1725490196, green: 0.1764705882, blue: 0.2078431373, alpha: 1).cgColor])
        self.view.backgroundColor = color
        dataSource = self
        delegate = self
        
        // Большой title в cityChooserVC
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .never
     
       
        
       
        DataManager.shared.fetchSavedCities() { geoResponces in
            let geoDictionary: [String : [GeoResponce]] = ["geo" : geoResponces]
            
            notificationCenter.post(name: .addGeoResponce,
                                    object: self,
                                    userInfo: geoDictionary)
            
            findInitialPageIndex()
        }
    
        networkManager.downloadWeatherConditionArray(for: geoResponces) { [self] weatherResponces  in
            for (i, weatherResponce) in weatherResponces.enumerated() {
                let vc = WeatherHomeVC(geoResponce: geoResponces[i],
                                       weatherResponce: weatherResponce.0,
                                       airPollutionResponce: weatherResponce.1)
                pages.append(vc)
            }
            
            setViewControllers([pages[initialPage]],
                               direction: .forward,
                               animated: false)
        }
    }
    
    private func configurePageControl() {
        pageControl.isEnabled = false
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = initialPage
    }
    
    private func configureToolBar() {
        toolBar.barTintColor = #colorLiteral(red: 0.1991047561, green: 0.2040857375, blue: 0.2466743588, alpha: 1)
        toolBar.isTranslucent = false
        toolBar.items = [flexibleSpaceBarButtonItem, listBarButtonItem]
    }

}



