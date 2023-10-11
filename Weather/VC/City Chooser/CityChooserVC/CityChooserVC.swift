//
//  CityChooserVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import UIKit

class CityChooserVC: UITableViewController {
    
    //MARK: Properties
    public var searchController: UISearchController! // подумать как убрать паблик
    /// public для weatherModalVC чтобы оттуда отправлять notification
    /// для имен городов
    public var geoResponces: [GeoResponce] = []
    /// Приходит с PageVC через notification
    /// для погоды в городе
    public var weatherResponces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = []
   
    internal let networkManager = NetworkManager()
    internal let notificationCenter = NotificationCenter.default
    /// Для отправки запроса поиска с задержкой
    internal var searchWorkItem: DispatchWorkItem?
    
    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        addNotificationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /**
     1. Инициализируется из PageVC
     2. В инициализаторе подписываемся на нотификации
     
     */

    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        /// Меняем цвет большого title
        navigationController?.navigationBar.largeTitleTextAttributes
        = [.foregroundColor : UIColor.red]
        /// Меняем цвет маленького title, появляется когда пропадает большой
        navigationController?.navigationBar.titleTextAttributes
        = [NSAttributedString.Key.foregroundColor: UIColor.red]
    }

    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureSearchController()
        configureNavigationItem()
    }
    
    private func configureSelf() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        tableView.register(SavedCitiesCell.self,
                           forCellReuseIdentifier: SavedCitiesCell.identifier)
    }
    
    private func configureSearchController() {
        let resultsVC = ResultsTableVC()
        resultsVC.parentCityChooserVC = self
        
        searchController = UISearchController(searchResultsController: resultsVC)
        searchController.searchBar.placeholder = "Поиск города"
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}






