//
//  PageVC+CityChooserDelegate.swift
//  Weather
//
//  Created by Арсений Кухарев on 11.10.2023.
//

import UIKit

protocol CityChooserVCDelegate: AnyObject {
    func pageRemove(at index: Int)
    func setCurrentVCTo(_ index: Int)
    func reorderPages(sourceIndex: Int,
                      destinationIndex: Int)
}

extension PageVC: CityChooserVCDelegate {
    
    /// Изменяем порядок элементов при перетаскивании ячеек в CityChooserVC
    func reorderPages(sourceIndex: Int,
                      destinationIndex: Int) {
        let page = pages[sourceIndex]
        pages.remove(at: sourceIndex)
        pages.insert(page, at: destinationIndex)
    }
    
    /// Устанавливаем currentVC из массива pages по входящему индексу
    func setCurrentVCTo(_ index: Int) {
        self.setViewControllers([pages[index]],
                                direction: .forward,
                                animated: false)
        self.updatePageControlCurrentPage(to: index)
    }
    
    /// Удаляем страницу из массива pages по указанному индексу
    func pageRemove(at index: Int) {
        self.pages.remove(at: index)
    }
}
