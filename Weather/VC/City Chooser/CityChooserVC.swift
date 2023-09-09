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
    public var geoResponces: [GeoResponce]
    /// Приходит с PageVC как только загрузится
    public var weatherResponceTuples: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]?
    
    private var resultsTableVC: ResultsTableVC?
    private let networkManager = NetworkManager()
    private var searchWorkItem: DispatchWorkItem?
    
    
    //MARK: - Init
    init(geoResponces: [GeoResponce]) {
        self.geoResponces = geoResponces
        super.init(nibName: nil, bundle: nil)
        print("CityChooserVC init 🧐")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CityChooserVC deinit 🧐")
    }
    
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CityChoser View Did Load 🧐")
        setupUI()
    }
    
    /// Из-за разных фонов WeatherVC и CityChoserVC нужно вручную менять цвет акцента верхнего navigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    

    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureSearchController()
    }
    
    private func configureSelf() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "Choose city" // поменять на Погода как в эпл погоде
        tableView.register(SuggestionCitiesCell.self, forCellReuseIdentifier: SuggestionCitiesCell.identifier)
    }
    
    private func configureSearchController() {
        resultsTableVC = ResultsTableVC()
        resultsTableVC?.parentCityChooserVC = self
        searchController = UISearchController(searchResultsController: resultsTableVC)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        searchController.searchResultsUpdater = self
    }

    /// Заполняем массив weatherResponceTuples данными, для отображения погодных условий в ячейках городов
    public func updateWeatherResponces(responceTuples: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]) {
        self.weatherResponceTuples = responceTuples
        self.tableView.reloadData()
    }
    
}


//MARK: - Table delegate / dataSource
extension CityChooserVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoResponces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, for: indexPath) as! SuggestionCitiesCell
        let geo = geoResponces[indexPath.row]
        
        cell.primaryText = geo.nameOfLocation ?? "nill"
 
        /// Если показали CityChoserVC до того как скачали погодные условия, то показывает прочерки
        if let responce = weatherResponceTuples?[indexPath.row] {
            cell.secondaryText = "\(responce.0.tempAndPressure?.temp ?? -100). \(responce.0.weatherDescription?.first?.description ?? "nil")"
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

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete")
        { action, view, completionHandler in
        
            let cityToDelete = self.geoResponces[indexPath.row]
            let cityToDeleteCD = DataManager.shared.convertAndFetch(geo: cityToDelete)
            
            /// Удаляем элемент из CD и self
            DataManager.shared.delete(cityToDeleteCD)
            self.weatherResponceTuples?.remove(at: indexPath.row)
            self.geoResponces.remove(at: indexPath.row)
            
            /// Удаляем элемент из PageVC
            if let pageVC = self.navigationController?.viewControllers[0] as? PageVC {
                pageVC.changePageControlPageAmount { $0.numberOfPages -= 1 }
                pageVC.pages.remove(at: indexPath.row)
            } else {
                print("Не удалось привести к PageVC 😨")
            }
            
            self.tableView.reloadData()
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
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
