//
//  PageVC+SubviewsLayout.swift
//  Weather
//
//  Created by Арсений Кухарев on 10.10.2023.
//

import UIKit

extension PageVC {
    
    internal func layoutToolBar() {
        self.view.addSubview(toolBar)
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            toolBar.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor),
            toolBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            toolBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            // Чтобы не выскакивала ошибка в консоль нужно вручную указывать высоту
            toolBar.heightAnchor.constraint(equalToConstant: 45)
        ])
    }
    
    internal func layoutPageControl() {
        self.view.addSubview(pageControl)
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            pageControl.centerYAnchor.constraint(equalTo: toolBar.centerYAnchor),
            pageControl.centerXAnchor.constraint(equalTo: toolBar.centerXAnchor)
        ])
    }
    
}
