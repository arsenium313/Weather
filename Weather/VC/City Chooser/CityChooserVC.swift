//
//  CityChooserVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import UIKit

class CityChooserVC: UITableViewController {
    
    //MARK: Properties
    public var searchController: UISearchController!
    /// public для weatherModalVC чтобы оттуда отправлять notification
    public var geoResponces: [GeoResponce] = []
    /// Приходит с PageVC как только загрузится
    public var weatherResponces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = []
    private var resultsTableVC: ResultsTableVC?
    private let networkManager = NetworkManager()
    private let notificationCenter = NotificationCenter.default
    /// Нужно для отправки запроса поиска с задержкой
    private var searchWorkItem: DispatchWorkItem?
    
    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        notificationCenter.addObserver(self, selector: #selector(reseveNotification(_:)),
                                       name: .geo, object: nil)
        notificationCenter.addObserver(self, selector: #selector(reseveNotification(_:)),
                                       name: .weather, object: nil)
        
     
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
        configureSearchController()
        configureSelf()
    }
    
    private func configureSelf() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        tableView.register(SuggestionCitiesCell.self,
                           forCellReuseIdentifier: SuggestionCitiesCell.identifier)
        
        /// Настройка  NavigationBar
        navigationItem.title = "Погода"
        navigationItem.largeTitleDisplayMode = .always
        navigationItem.rightBarButtonItem = editBarButtonItem
        navigationItem.hidesBackButton = true
    }
    
    private func configureSearchController() {
        resultsTableVC = ResultsTableVC()
        resultsTableVC?.parentCityChooserVC = self
        
        searchController = UISearchController(searchResultsController: resultsTableVC)
        searchController.searchBar.placeholder = "Поиск города"
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        searchController.searchResultsUpdater = self
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }

    
    // MARK: - UIBarButtonItem Creation and Configuration
    /// Включает режим редактирования
    private var editBarButtonItem: UIBarButtonItem {
        let image = UIImage(systemName: "ellipsis.circle")
        let button = UIBarButtonItem(image: image, style: .plain, target: self,
                                     action: #selector(barButtonItemClicked(_:)))
        button.tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        return button
    }
   
    
    // MARK: - Work With TableView
    private func deleteRow(at indexPath: IndexPath) {
        let cityToDelete = self.geoResponces[indexPath.row]
        if let cityToDeleteCD = DataManager.shared.convertAndFetch(geo: cityToDelete) {
            DataManager.shared.delete(cityToDeleteCD)
        }
        
        self.weatherResponces.remove(at: indexPath.row)
        self.geoResponces.remove(at: indexPath.row)
        
        
        let geoDictionary: [String : [GeoResponce]] = ["geo" : self.geoResponces]
        notificationCenter.post(name: .geo, object: self, userInfo: geoDictionary)
        
        guard let pageVC = navigationController?.viewControllers[0] as? PageVC else { return }
        pageVC.pages.remove(at: indexPath.row)
    }
    
    
    // MARK: - @objc
    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        if tableView.isEditing {
            DataManager.shared.changeIndex(geoArray: geoResponces)
            tableView.setEditing(false, animated: true)
        } else {
            tableView.setEditing(true, animated: true)
        }
    }
    
    @objc
    private func reseveNotification(_ sender: Notification) {
        switch sender.name {
            
        case .weather:
            guard let weatherResponce = sender.userInfo?["weather"]
                    as? [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] else { return }
            self.weatherResponces = weatherResponce
            self.tableView.reloadData()
            
        case .geo:
            guard let geo = sender.userInfo?["geo"] as? [GeoResponce] else { return }
            self.geoResponces = geo
            self.tableView.reloadData()
            
        default: return
        }
    }
    
}


//MARK: - TableView Delegate / DataSource
extension CityChooserVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoResponces.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier,
                                                 for: indexPath) as! SuggestionCitiesCell
        let geo = geoResponces[indexPath.row]
        
        cell.primaryText = geo.nameOfLocation ?? "- -"
        
        /// Если показали CityChoserVC до того как скачали погодные условия, то показывает прочерки
        if !weatherResponces.isEmpty {
            let weatherResponce = weatherResponces[indexPath.row]
            cell.secondaryText = "\(weatherResponce.0.tempAndPressure?.temp ?? -100). \(weatherResponce.0.weatherDescription?.first?.description ?? "nil")"
        } else {
            cell.secondaryText = "- -"
        }
        
        cell.setupUI()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pageVC = navigationController?.viewControllers[0] as? PageVC else { return }
        let index = indexPath.row
            
        /// Обновляем PageVC
        pageVC.setViewControllers([pageVC.pages[index]], direction: .forward, animated: false)
        pageVC.updatePageControlCurrentPage(to: index)
        
        /// Устанавливаем isFirstToShow flag
        DataManager.shared.setIsFirstToShowFlag(geo: geoResponces[index])
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView,
                            trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete")
        { action, view, completionHandler in
            self.deleteRow(at: indexPath)
            completionHandler(true)
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView,
                            moveRowAt sourceIndexPath: IndexPath,
                            to destinationIndexPath: IndexPath) {
        /// Изменяем массив geoResponces при перемещении ячеек
        let geoItem = geoResponces[sourceIndexPath.row]
        geoResponces.remove(at: sourceIndexPath.row)
        geoResponces.insert(geoItem, at: destinationIndexPath.row)
        
        /// Изменяем массив weatherResponces при перемещении ячеек
        let weatherItem = weatherResponces[sourceIndexPath.row]
        weatherResponces.remove(at: sourceIndexPath.row)
        weatherResponces.insert(weatherItem, at: destinationIndexPath.row)
        
        
        guard let pageVC = navigationController?.viewControllers[0] as? PageVC else { return }
        let page = pageVC.pages[sourceIndexPath.row]
        pageVC.pages.remove(at: sourceIndexPath.row)
        pageVC.pages.insert(page, at: destinationIndexPath.row)
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        /// Кнопка в режиме редактирования таблицы "Удалить", действия соответствующие
        deleteRow(at: indexPath)
    }
    
}


//MARK: - Search Updater
extension CityChooserVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchWorkItem?.cancel()
        
        /// Поиск координат по текстовому полю
        let workItem = DispatchWorkItem {
            let cityName = searchController.searchBar.text
            self.networkManager.getCoordinateByCityName(cityName: cityName ?? "") { responces in
                DispatchQueue.main.async {
                    self.resultsTableVC?.geoResponces = responces
                    self.resultsTableVC?.tableView.reloadData()
                }
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: workItem)
    }
}
