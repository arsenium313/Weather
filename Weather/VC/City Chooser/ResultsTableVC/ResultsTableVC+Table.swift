//
//  ResultsTableVC+Table.swift
//  Weather
//
//  Created by Арсений Кухарев on 11.10.2023.
//

import UIKit

extension ResultsTableVC {
    
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, 
                            numberOfRowsInSection section: Int) -> Int {
        return searchResults.count
    }

    override func tableView(_ tableView: UITableView, 
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let geo = searchResults[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, 
                                                 for: indexPath) as! SuggestionCitiesCell
        cell.configureCell(with: geo)
        return cell
    }

    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, 
                            didSelectRowAt indexPath: IndexPath) {
        let geo = searchResults[indexPath.row]
        let modalVC = WeatherModalVC(geoResponce: geo, 
                                     cityChoserVC: parentCityChooserVC)
        let navigationVC = UINavigationController(rootViewController: modalVC)
        present(navigationVC, animated: true)
    }
}
