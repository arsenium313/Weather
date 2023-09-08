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
    public var initialPage = 0 // индекс в массиве VC который с isFirstToShow
    public var pages: [WeatherHomeVC] = []
    private let pageControl = UIPageControl()
    private let toolBar = UIToolbar()
    private var savedCities: [GeoResponce] = [] // Нужно для быстрого отображения точек в pageControl(не ждать пока все загрузятся)
    private var savedResponces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = [] // для последующего обновления view
    
    
    // MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Page vc ViewDidLoad!")
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
            self.savedCities = geoResponces
            fillPagesArray()
            // Указываем VC который нужно отобразить первым
            setViewControllers([pages[initialPage]], direction: .forward, animated: true)
        }
  
        networkManager.downloadWeatherConditionArray(for: savedCities) { responces in
            // Для уже созданных WeatherVC которые лежат в массиве pages, обновляем bundleView скачанными погодными данными
            self.savedResponces = responces
            for (i, vc) in self.pages.enumerated() {
                let geo = self.savedCities[i]
                vc.bundleView.setupUI(forGeo: geo, using: responces[i].0, responces[i].1)
            }
        }
        
    }
    
    /// Создаём WeatherHomeVC в количестве сохранённых в CD городов, и помещаем их в массив pages
    private func fillPagesArray() {
        for _ in 0...savedCities.count - 1 {
            let vc = WeatherHomeVC()
            pages.append(vc)
        }
    }
    
    private func configurePageControl() {
        pageControl.numberOfPages = savedCities.count
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
        toolBar.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        toolBar.items = [flexibleSpaceBarButtonItem, listBarButtonItem]
        
        self.view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
        ])
    }
    
    
    //MARK: - UIBarButtonItem Creation and Configuration
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
        print("Bar Button Clicked")
//        pushViewController(cityChoserVC, animated: true)
        let vc = CityChooserVC(geoResponces: savedCities, weatherResponces: savedResponces)
//        vc.modalPresentationStyle = .fullScreen
//        present(vc, animated: true)
        navigationController?.pushViewController(vc, animated: true)
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
    }
}
