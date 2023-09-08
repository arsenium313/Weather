//
//  PageVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.09.2023.
//

import UIKit

class PageVC: UIPageViewController {

    // MARK: Properties
    public var initialPage = 0 // индекс в массиве VC который с isFirstToShow
    private let pageControl = UIPageControl()
    private var pages: [WeatherHomeVC] = []
    private var savedCities: [GeoResponce] = [] // Нужно для быстрого отображения точек в pageControl(не ждать пока все загрузятся)
    private var savedResponces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = [] // для последующего обновления view
    let networkManager = NetworkManager()
    
    
    // MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Page vc ViewDidLoad!")
        setupUI()
    }
    

    // MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configurePageControl()
    }

    private func configureSelf() {
        self.view.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        dataSource = self
        delegate = self
        DataManager.shared.fetch() { geoResponces in
            self.savedCities = geoResponces
        }
        createWeatherVC()
        // загружаем
        setViewControllers([pages[initialPage]], direction: .forward, animated: true)
        print("Pages count - - \(pages.count)")
        
        networkManager.downloadWeatherConditionArray(for: savedCities) { responces in
            for (i, vc) in self.pages.enumerated() {
                let geo = self.savedCities[i]
                vc.bundleView.setupUI(forGeo: geo, using: responces[i].0, responces[i].1)
            }
        }
    }
    
    private func createWeatherVC() {
        for _ in 0...savedCities.count - 1 {
            let vc = WeatherHomeVC()
            pages.append(vc)
        }
    }
    
    private func configurePageControl() {
        pageControl.numberOfPages = savedCities.count
        pageControl.pageIndicatorTintColor = #colorLiteral(red: 0.9372549057, green: 0.3490196168, blue: 0.1921568662, alpha: 1)
        pageControl.currentPageIndicatorTintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        pageControl.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1)
        pageControl.currentPage = initialPage // начинается с 0
        
        pageControl.addTarget(self, action: #selector(pageControlClicked(_:)), for: .valueChanged)
        
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            pageControl.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor)
        ])
        
    }
    
    
    // MARK: - @objc
    @objc
    private func pageControlClicked(_: UIPageControl) {
        print("Page Control Clicked!")
    }
}


// MARK: - UIPageVC Data Source
extension PageVC: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentIndex = pages.firstIndex(of: viewController as! WeatherHomeVC) else { return nil }
        print("Pages count = \(pages.count)")
        if currentIndex == 0 { // Если экран самый левый, по кругу не возвращаемся
            return nil
        } else {
            return pages[currentIndex - 1]
        }
    }
    
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
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = pages.firstIndex(of: viewControllers[0] as! WeatherHomeVC) else { return }
        
        pageControl.currentPage = currentIndex
    }
}
