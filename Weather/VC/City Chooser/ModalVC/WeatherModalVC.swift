//
//  WeatherModalVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 01.09.2023.
//

import UIKit

class WeatherModalVC: UIViewController {

    //MARK: Properties
    private let networkManager = NetworkManager()
    internal let notificationCenter = NotificationCenter.default
    internal var collectionView: UICollectionView?
    internal var dataSource: UICollectionViewDiffableDataSource<SectionLayoutKind, CellIdentifier>! = nil
    private let collectionViewConfig = CollectionViewConfigurator()
    
    internal var geoResponce: GeoResponce
    internal var weatherResponce: OpenWeatherResponce?
    internal var airPollutionResponce: OpenWeatherAirPollutionResponce?

    /// Нужен для сохранения geo в CD
    internal let index: Int
    
    
    // MARK: - Init
    init(geoResponce geo: GeoResponce, tableCount index: Int) {
        self.index = index
        self.geoResponce = geo
        super.init(nibName: nil, bundle: nil)
        
        networkManager.downloadWeatherCondition(for: geo) { tuple in
            self.weatherResponce = tuple.0
            self.airPollutionResponce = tuple.1
            self.configureDataSource()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    

    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureCollectionView()
    }
    
    private func configureSelf() {
        navigationItem.rightBarButtonItem = addBarButton
        self.view.backgroundColor = UIColor.createGradientColor(in: self.view.bounds,
                                                                for: [#colorLiteral(red: 0.2831242383, green: 0.2937351763, blue: 0.3573759198, alpha: 1).cgColor,
                                                                      #colorLiteral(red: 0.1725490196, green: 0.1764705882, blue: 0.2078431373, alpha: 1).cgColor])
        
        /// Делаем верхний bar прозрачным при скролле
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithTransparentBackground()
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
    }
    
    private func configureCollectionView() {
        collectionView = UICollectionView(frame: .zero,
                                          collectionViewLayout: collectionViewConfig.createLayout())
        guard let cv = collectionView else { return }
        cv.backgroundColor = .red
        cv.backgroundColor = .none
        cv.showsVerticalScrollIndicator = false
        self.view.addSubview(cv)
        
        let guide = self.view.layoutMarginsGuide
        cv.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cv.topAnchor.constraint(equalTo: guide.topAnchor),
            cv.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            cv.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            cv.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
    }

}
