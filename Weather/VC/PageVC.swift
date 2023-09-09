//
//  PageVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.09.2023.
//

import UIKit

class PageVC: UIPageViewController {

    // MARK: Properties
    public let networkManager = NetworkManager()
    /// индекс в массиве VC который с isFirstToShow
    public var initialPage = 0
    public var pages: [WeatherHomeVC] = []
   
    private let pageControl = UIPageControl()
    private let toolBar = UIToolbar()
    /// Нужно для быстрого отображения точек в pageControl(не ждать пока все загрузятся)
    private var geoResponces: [GeoResponce] = []
   
    private var cityChooserVC: CityChooserVC!
    
    
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
        self.view.backgroundColor = #colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)
        dataSource = self
        delegate = self
        
        DataManager.shared.fetchSavedCities() { geoResponces in
            self.geoResponces = geoResponces
            self.cityChooserVC = CityChooserVC(geoResponces: geoResponces)
            
            /// Создаем WeatherHomeVC в количестве savedCities.count
            fillPagesArray()
            
            // тут ищем isFirstToShow и устанавливаем initialPage
            
            /// Устанавливаем первый VC
            setViewControllers([pages[initialPage]], direction: .forward, animated: true)
        }
  
        networkManager.downloadWeatherConditionArray(for: geoResponces) { weatherResponces  in
            /// Отправляем weatherResponce в CityChooserVC c этой инфо рисуется ячейка
            self.cityChooserVC.updateWeatherResponces(responceTuples: weatherResponces)
            
            /// Для уже созданных WeatherVC которые лежат в массиве pages, обновляем bundleView скачанными погодными данными
            for (i, weatherHomeVC) in self.pages.enumerated() {
                let geo = self.geoResponces[i]
                weatherHomeVC.bundleView.setupUI(forGeo: geo, using: weatherResponces[i].0, weatherResponces[i].1)
            }
        }
        
    }

    
    private func configurePageControl() {
        pageControl.numberOfPages = geoResponces.count
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pageControl.backgroundColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        pageControl.currentPage = initialPage // начинается с 0
        pageControl.addTarget(self, action: #selector(pageControlClicked(_:)), for: .valueChanged)
        
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor),
            pageControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor)
        ])
    }
    

    
    private func configureToolBar() {
        toolBar.backgroundColor = #colorLiteral(red: 0.05882352963, green: 0.180392161, blue: 0.2470588237, alpha: 1)
        toolBar.items = [flexibleSpaceBarButtonItem, listBarButtonItem]
        
        self.view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    
    // MARK: - Update PageControl
    /// Обновляет CurrentPage для указанного индекса
    public func updatePageControlCurrentPage(to index: Int) {
        let number = pageControl.numberOfPages
        pageControl.numberOfPages = 0
        pageControl.numberOfPages = number
        pageControl.currentPage = index
    }
    
    /// Возвращает в замыкании PageControl для изменения количества точек
    public func changePageControlPageAmount(_ handler: (UIPageControl) -> Void) {
        handler(self.pageControl)
    }
    
    
    // MARK: - Update Pages Array
    /// Создаём WeatherHomeVC в количестве сохранённых в CD городов, и помещаем их в массив pages
    private func fillPagesArray() {
        for _ in 0...geoResponces.count - 1 {
            let vc = WeatherHomeVC()
            pages.append(vc)
        }
    }
    
    
    // MARK: - UIBarButtonItem Creation and Configuration
    private var flexibleSpaceBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    }
    private var listBarButtonItem: UIBarButtonItem {
        let image = UIImage(systemName: "list.bullet")
        return UIBarButtonItem(image: image, style: .plain, target: self,
                               action: #selector(barButtonItemClicked(_:)))
    }
    
    
    // MARK: - @objc
    @objc
    private func pageControlClicked(_ sender: UIPageControl) {
        let currentPage = sender.currentPage
        setViewControllers([pages[currentPage]], direction: .forward, animated: true)
    }
    
    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        print("PageVC Bar Button Clicked 🧐")
      //  let vc = CityChooserVC(geoResponces: savedCities, weatherResponces: savedResponces) // убрать отсюда вверх чтоб не создавался каждый раз

        navigationController?.pushViewController(cityChooserVC, animated: true)
    }
}


// MARK: - UIPageVC Data Source
extension PageVC: UIPageViewControllerDataSource {
    /// Устанавливаем предыдущие VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! WeatherHomeVC) else { return nil }
        if currentIndex == 0 { // Если экран самый левый, по кругу не возвращаемся
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
    /// Устанавливаем следующие VC
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! WeatherHomeVC) else { return nil }
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
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0] as! WeatherHomeVC) else { return }
        
        pageControl.currentPage = currentIndex
        // делаем currentVC = isFirstToShow
    }
}
