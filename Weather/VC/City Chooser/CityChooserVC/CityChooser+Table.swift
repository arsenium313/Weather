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
         4. Удаляем из PageVC ненужную страницу
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
        notificationCenter.post(name: .geoArray, 
                                object: self,
                                userInfo: [NSNotification.keyName : geoResponces])
        
        // 4
        delegate?.pageRemove(at: indexPath.row)
    }
    
    
    //MARK: - numberOfRowsInSection
    override func tableView(_ tableView: UITableView, 
                            numberOfRowsInSection section: Int) -> Int {
        
        return geoResponces.count
    }
    
    
    //MARK: - cellForRowAt
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: SavedCitiesCell.identifier,
                                                 for: indexPath) as! SavedCitiesCell
        let geo = geoResponces[indexPath.row]
     
        /// Если показали CityChoserVC, а погоды еще нет, то передаёт nil вместо погодных условий
        if !weatherResponces.isEmpty {
            let weatherResponce = weatherResponces[indexPath.row]
            cell.setupUI(withGeo: geo,
                         withWeather: weatherResponce)
        } else {
            cell.setupUI(withGeo: geo,
                         withWeather: nil)
        }
        
        return cell
    }
    
    
    //MARK: - didSelectRowAt
    override func tableView(_ tableView: UITableView, 
                            didSelectRowAt indexPath: IndexPath) {
        
        /// Обновляем currentPage в PageVC
        let index = indexPath.row
        delegate?.setCurrentVCTo(index)
 
        /// Устанавливаем какой город показывать первым при запуске
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
        
        /// Изменяем массив geoResponces при перетаскивании ячеек
        let geoItem = geoResponces[sourceIndexPath.row]
        geoResponces.remove(at: sourceIndexPath.row)
        geoResponces.insert(geoItem, at: destinationIndexPath.row)
        
        /// Изменяем массив weatherResponces при перетаскивании ячеек
        let weatherItem = weatherResponces[sourceIndexPath.row]
        weatherResponces.remove(at: sourceIndexPath.row)
        weatherResponces.insert(weatherItem, at: destinationIndexPath.row)
        
        /// Изменяем массив pages в PageVC при перетаскивании ячеек
        delegate?.reorderPages(sourceIndex: sourceIndexPath.row,
                              destinationIndex: destinationIndexPath.row)
    }
    
    
    //MARK: - commit forRowAt
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        /// Дейтсвия на нажатие кнопки появляющейся в режиме редактирования таблицы:
        deleteRow(at: indexPath)
    }
    
}
