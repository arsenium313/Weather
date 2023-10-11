//
//  CityChooser+NavigationItem.swift
//  Weather
//
//  Created by Арсений Кухарев on 11.10.2023.
//

import UIKit

extension CityChooserVC {
    
    /// Настройка  NavigationBar
    internal func configureNavigationItem() {
        navigationItem.title = "Погода"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = editBarButtonItem
        navigationItem.hidesBackButton = true
    }
    
    /// Включает режим редактирования
    private var editBarButtonItem: UIBarButtonItem {
        let image = UIImage(systemName: "ellipsis.circle")
        let button = UIBarButtonItem(image: image, 
                                     style: .plain,
                                     target: self,
                                     action: #selector(barButtonItemClicked(_:)))
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return button
    }

    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            DataManager.shared.changeIndex(geoArray: geoResponces)
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
}
