//
//  AirQualityView+ConfigureViewProtocol.swift
//  Weather
//
//  Created by Арсений Кухарев on 08.10.2023.
//

import Foundation
/**
 1.  Ячейка collectionView создаёт view
 2.  Ячейка позиционирует view
 3.  Вручную запускаем создание UI у subview когда знаем bounds этих subview
 */
extension AirQualityView: ConfigureViewProtocol {
    public func configureView() {
        setupUI()
    }
}
