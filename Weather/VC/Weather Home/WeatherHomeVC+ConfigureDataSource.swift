//
//  WeatherHomeVC+ConfigureDataSource.swift
//  Weather
//
//  Created by Арсений Кухарев on 17.09.2023.
//

import UIKit

extension WeatherHomeVC {
        
    internal func configureDataSource() {
      
        // MARK: Cell Registration
        let cellRegistation = UICollectionView.CellRegistration<CustomCell, CellIdentifier>
        { cell, indexPath, itemIdentifier in
            switch itemIdentifier {
            case .title:
                cell.setupUI(for: .title, responce: self.geoResponce)
            case .weather:
                cell.setupUI(for: .weather, responce: self.weatherResponce)
            case .sun:
                cell.setupUI(for: .sun, responce: self.weatherResponce)
            case .airPollution:
                cell.setupUI(for: .airPollution, responce: self.airPollutionResponce)
            case .blank:
                cell.setupUI(for: .blank, responce: 0)
            }
        }
        
        
        // MARK: - DataSource
        dataSource = UICollectionViewDiffableDataSource<SectionLayoutKind, CellIdentifier>(collectionView: collectionView)
        { (collectionView, indexPath, itemIdentifier: CellIdentifier) -> UICollectionViewCell in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistation,
                                                                for: indexPath,
                                                                item: itemIdentifier)
        }
        
        
        // MARK: - Snapshoot
        var snapshoot = NSDiffableDataSourceSnapshot<SectionLayoutKind, CellIdentifier>()
        snapshoot.appendSections([.top, .middle, .bottom])
        snapshoot.appendItems([.title], toSection: .top)
        snapshoot.appendItems([.weather, .sun], toSection: .middle)
        snapshoot.appendItems([.airPollution], toSection: .bottom)
        dataSource.apply(snapshoot,animatingDifferences: true)
    }
}
