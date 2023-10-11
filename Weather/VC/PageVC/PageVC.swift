//
//  PageVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.09.2023.
//

import UIKit

class PageVC: UIPageViewController {

    // MARK: Properties
    public var pages: [WeatherHomeVC] = [] // зачем public?
   
    private let networkManager = NetworkManager()
    internal let notificationCenter = NotificationCenter.default
    
    internal let pageControl = UIPageControl()
    /// Чтобы не выскакивала ошибка в консоль, нужно вручную указывать CGSize toolBar при инициализации
    internal let toolBar = UIToolbar(frame: CGRect(origin: .zero,
                                                   size: CGSize(width: UIScreen.main.bounds.width,
                                                                height: 45)))
    internal var initialPageIndex = 0
    /// Заполняется из reseveNotification
    internal var geoResponces: [GeoResponce] = []
    internal var weatherResponces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = []
    /// Инициализируем здесь чтобы при notification .weather информация уже пришла в cityChooserVC
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
        
        /**
         1. Скачиваем из CoreData массив координат городов
         2. Отправляем нотификацию .geo:
         – заполнится массив geoResponce
         – установит количество точек в pageControl
         3. Устанавливаем первоначальный индекс, из него будут:
         – установлена первая отображаемая page
         – установлен currentPage в pageControl
         4. Скачиваем данные для массива координат
         5. Создаём ViewControllers и помещаем их в массив
         6. Устанавливаем для PageVC массив с VC для отображения
         7. Отправляем нотификацию .weather
         */
        
        // 1
        DataManager.shared.fetchSavedCities() { geoResponces in
            let geoDictionary: [String : [GeoResponce]] = ["geo" : geoResponces]
            // 2
            notificationCenter.post(name: .geo,
                                    object: self,
                                    userInfo: geoDictionary)
            // 3
            // Устанавливаем currentPage до того как скачаются данные
            self.initialPageIndex = getFirstToShowIndex()
        }
        
        // 4
        networkManager.downloadWeatherConditionArray(for: geoResponces) { [self] responce  in
            for (i, responce) in responce.enumerated() {
                // 5
                let vc = WeatherHomeVC(geoResponce: geoResponces[i],
                                       weatherResponce: responce.0,
                                       airPollutionResponce: responce.1)
                pages.append(vc)
            }
            // 6
            self.setViewControllers([pages[initialPageIndex]],
                                    direction: .forward,
                                    animated: false)
            // 7
            sendNotification(withData: responce)
        }
    }
    
    private func configurePageControl() {
        pageControl.isEnabled = false
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        pageControl.hidesForSinglePage = true
        pageControl.currentPage = initialPageIndex
    }
    
    private func configureToolBar() {
        toolBar.barTintColor = #colorLiteral(red: 0.1991047561, green: 0.2040857375, blue: 0.2466743588, alpha: 1)
        toolBar.isTranslucent = false
        toolBar.items = [flexibleSpaceBarButtonItem, listBarButtonItem]
    }

}



