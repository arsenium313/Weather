//
//  ConfigureViewProtocol.swift
//  Weather
//
//  Created by Арсений Кухарев on 08.10.2023.
//

import Foundation

/// Запускаем создание UI у subview когда знаем bounds этих subview
protocol ConfigureViewProtocol {
   /// Вручную запускаем создание UI, bounds уже известны
    func configureView()
}
