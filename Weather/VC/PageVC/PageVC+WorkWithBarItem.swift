//
//  PageVC+WorkWithBar.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.10.2023.
//

import UIKit

extension PageVC {
    
    internal var flexibleSpaceBarButtonItem: UIBarButtonItem {
        return UIBarButtonItem(barButtonSystemItem: .flexibleSpace, 
                               target: nil,
                               action: nil)
    }
    
    internal var listBarButtonItem: UIBarButtonItem {
        let image = UIImage(systemName: "list.bullet")
        let button =  UIBarButtonItem(image: image, 
                                      style: .done,
                                      target: self,
                                      action: #selector(barButtonItemClicked(_:)))
        button.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        return button
    }
    
    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        navigationController?.pushViewController(cityChooserVC, 
                                                 animated: true)
    }
    
}

