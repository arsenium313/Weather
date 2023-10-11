//
//  CityChooser+Delegate+DataSource.swift
//  Weather
//
//  Created by Арсений Кухарев on 11.10.2023.
//

import UIKit


extension CityChooserVC {
    
    internal func deleteRow(at indexPath: IndexPath) {
        /**
         1. Удаляем из CD
         2. Удаляем из табличных массивов
         3. Отправляет  нотификацию с обновленным массом geoResponces
         Тут:
         - Обновляет табличный массив
         - Обновляет таблицу
         В PageVC:
         - Обновляет массив geoResponce(после свайпов в pageVC присваивается правильный индекс в isFirstToShow)
         - Обновляет количество точек в pageControl
         4.
         */
        
        // 1
        let cityToDelete = self.geoResponces[indexPath.row]
        if let cityToDeleteCD = DataManager.shared.convertAndFetch(geo: cityToDelete) {
            DataManager.shared.delete(cityToDeleteCD)
        }
        // 2
        self.weatherResponces.remove(at: indexPath.row)
        self.geoResponces.remove(at: indexPath.row)
        
        // 3
        let geoDictionary: [String : [GeoResponce]] = ["geo" : self.geoResponces]
        notificationCenter.post(name: .geo, object: self, userInfo: geoDictionary)
        
        // 4
        guard let pageVC = navigationController?.viewControllers[0] as? PageVC else { return }
        pageVC.pages.remove(at: indexPath.row) // вывести в делегат
    }
    
    
    //MARK: - numberOfRowsInSection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoResponces.count
    }
    
    
    //MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedCitiesCell.identifier,
                                                 for: indexPath) as! SavedCitiesCell
        let geo = geoResponces[indexPath.row]
        
        cell.primaryText = geo.nameOfLocation ?? "- -"
        
        /// Если показали CityChoserVC до того как скачали погодные условия, то показывает прочерки
        if !weatherResponces.isEmpty {
            let weatherResponce = weatherResponces[indexPath.row]
            cell.secondaryText = "\(weatherResponce.0.tempAndPressure?.temp ?? -100). \(weatherResponce.0.weatherDescription?.first?.description ?? "nil")"
        } else {
            cell.secondaryText = "- -"
        }
        
        cell.configureView()
        return cell
    }
    
    
    //MARK: - didSelectRowAt
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pageVC = navigationController?.viewControllers[0] as? PageVC else { return }
        let index = indexPath.row
            
        /// Обновляем PageVC
        pageVC.setViewControllers([pageVC.pages[index]], direction: .forward, animated: false)
        pageVC.updatePageControlCurrentPage(to: index)
        
        /// Устанавливаем isFirstToShow flag
        DataManager.shared.setIsFirstToShowFlag(geo: geoResponces[index])
        self.navigationController?.popToRootViewController(animated: true)
    }

    
    //MARK: - trailingSwipeActionsConfigurationForRowAt
    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete")
        { action, view, completionHandler in
            self.deleteRow(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    
    //MARK: - moveRowAt
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        /// Изменяем массив geoResponces при перемещении ячеек
        let geoItem = geoResponces[sourceIndexPath.row]
        geoResponces.remove(at: sourceIndexPath.row)
        geoResponces.insert(geoItem, at: destinationIndexPath.row)
        
        /// Изменяем массив weatherResponces при перемещении ячеек
        let weatherItem = weatherResponces[sourceIndexPath.row]
        weatherResponces.remove(at: sourceIndexPath.row)
        weatherResponces.insert(weatherItem, at: destinationIndexPath.row)
        
        
        guard let pageVC = navigationController?.viewControllers[0] as? PageVC else { return }
        let page = pageVC.pages[sourceIndexPath.row]
        pageVC.pages.remove(at: sourceIndexPath.row)
        pageVC.pages.insert(page, at: destinationIndexPath.row)
    }
    
    
    //MARK: - commit forRowAt
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        /// Кнопка в режиме редактирования таблицы "Удалить", действия соответствующие
        deleteRow(at: indexPath)
    }
    
}
