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
        print("WeatherHomeVC Init ✅")
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("WeatherHomeVC deinit ❌")
    }
    
    
    // MARK: - View Life Circle
    override func loadView() {
        let view = GradientRootView()
        self.view = view
    }
    
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
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.backgroundColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        
        self.view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let guide = self.view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: guide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: guide.bottomAnchor,constant: -45)
        ])
    }

    
}








