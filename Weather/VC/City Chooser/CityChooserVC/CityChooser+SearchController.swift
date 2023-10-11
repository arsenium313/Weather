//
//  CityChooser+SearchController.swift
//  Weather
//
//  Created by Арсений Кухарев on 11.10.2023.
//

import UIKit

extension CityChooserVC: UISearchResultsUpdating {
    
    /// Вызывается при каждом изменении поля search
    func updateSearchResults(for searchController: UISearchController) {
        searchWorkItem?.cancel()
        guard let resutltsVC = self.searchController.searchResultsController as? ResultsTableVC else { return }
        
        /// Поиск координат по текстовому полю
        let workItem = DispatchWorkItem {
            let name = searchController.searchBar.text ?? ""
            self.networkManager.getCoordinate(forCityName: name) { responces in
                DispatchQueue.main.async {
                    resutltsVC.fillGeoResponces(with: responces)
                    resutltsVC.tableView.reloadData()
                }
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, 
                                      execute: workItem)
    }
}
