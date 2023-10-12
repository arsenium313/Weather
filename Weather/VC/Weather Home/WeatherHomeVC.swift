//
//  ViewController.swift
//  Weather
//
//  Created by Арсений Кухарев on 05.07.2023.
//

import UIKit

class WeatherHomeVC: UIViewController {

    //MARK: Properties    
    internal var collectionView: UICollectionView!
    internal var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, CellIdentifier>! = nil
    private let collectionViewConfig = CollectionViewConfigurator()
    internal var geoResponce: GeoResponce?
    internal var weatherResponce: OpenWeatherResponce?
    internal var airPollutionResponce: OpenWeatherAirPollutionResponce?
    
    
    // MARK: - Init
    init(geoResponce: GeoResponce,
         weatherResponce: OpenWeatherResponce,
         airPollutionResponce: OpenWeatherAirPollutionResponce) {
       
        self.geoResponce = geoResponce
        self.weatherResponce = weatherResponce
        self.airPollutionResponce = airPollutionResponce

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureCollectionView()
        configureDataSource()
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero, 
                                          collectionViewLayout: collectionViewConfig.createLayout())
        collectionView.backgroundColor = .none
        collectionView.showsVerticalScrollIndicator = false
        self.view.addSubview(collectionView)
        
        let guide = self.view.layoutMarginsGuide
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor,constant: -45)
        ])
    }
    
}








