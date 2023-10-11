//
//  PageVC+DataSource+Delegate.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.10.2023.
//

import UIKit

extension PageVC: UIPageViewControllerDataSource {
    /// Предыдущий VC
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
    
    /// Следующий VC
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
