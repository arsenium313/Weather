//
//  WeatherHomeVC+CreateLayout.swift
//  Weather
//
//  Created by Арсений Кухарев on 17.09.2023.
//

import UIKit

extension WeatherHomeVC {
    
    internal func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout
        { (sectionIndex, _) -> NSCollectionLayoutSection? in
            guard let sectionLayoutKind = SectionLayoutKind(rawValue: sectionIndex)
            else { return nil }
            
            switch sectionLayoutKind {
            case .top:
                return self.createTopSection()
            case .middle:
                return self.createMiddleSection()
            case .bottom:
                return self.createBottomSection()
            }
        }
        
        let config = UICollectionViewCompositionalLayoutConfiguration()
        config.interSectionSpacing = 10
        layout.configuration = config
        return layout
    }
    
    private func createTopSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.1))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
    private func createMiddleSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.3))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 5
        return section
    }
    
    private func createBottomSection() -> NSCollectionLayoutSection {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                             heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .fractionalHeight(0.28))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                       subitem: item, count: 2)
        
        let section = NSCollectionLayoutSection(group: group)
        return section
    }
    
}
