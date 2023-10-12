//
//  CityChooserVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import UIKit

class CityChooserVC: UITableViewController {
    
    //MARK: Properties
    internal var searchController: UISearchController!
    internal weak var delegate: CityChooserVCDelegate?
    internal let networkManager = NetworkManager()
    internal let notificationCenter = NotificationCenter.default
    
    /// Приходит через notification, для имен городов в ячейках
    internal var geoResponces: [GeoResponce] = []
    
    /// Приходит через notification, для погоды в ячейках
    internal var weatherResponces: [OpenWeatherResponce] = []
   
    /// Для отправки поискового поиска с задержкой при наборе текста
    internal var searchWorkItem: DispatchWorkItem?
    

    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        addNotificationObserver()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


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
        let resultsVC = ResultsTableVC(index: geoResponces.count)

        searchController = UISearchController(searchResultsController: resultsVC)
        searchController.searchBar.placeholder = "Поиск города"
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

}






