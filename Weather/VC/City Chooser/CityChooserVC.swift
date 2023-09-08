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
    public var resultsTableVC: ResultsTableVC?
    public weak var delegate: CityChooserDelegate?
    private let networkManager = NetworkManager()
    private var searchWorkItem: DispatchWorkItem?
    
    private var savedCities: [GeoResponce] = []
    public var savedResponces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = []
    
    
    //MARK: - Init
    init(geoResponces: [GeoResponce], weatherResponces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]) {
        super.init(nibName: nil, bundle: nil)
        print("City Chooser init")
//        DataManager.shared.fetchSavedCities { geoResponces in
//            self.savedCities = geoResponces
//        }
       // updateSavedCities()
//        updateResponces()
        
        self.savedCities = geoResponces
        self.savedResponces = weatherResponces
        
        
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("City Chooser deinit")
    }
    
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CityChoser ViewDidLoad")
        setupUI()
    }
    
    // Из-за разных фонов WeatherVC и CityChoserVC нужно вручную менять цвет акцента верхнего navigationBar
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
        print("_________________________________________(£)@()*£)(£@)*\(isModalInPresentation)")
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "Choose city"
        tableView.register(SuggestionCitiesCell.self, forCellReuseIdentifier: SuggestionCitiesCell.identifier)
        
    }
    
    private func configureSearchController() {
        resultsTableVC = ResultsTableVC()
        resultsTableVC?.parentTest = self
        searchController = UISearchController(searchResultsController: resultsTableVC)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        searchController.searchResultsUpdater = self
    }
    
    /// Скачивает из CD все объекты
    func updateSavedCities() {
       // savedCities = DataManager.shared.fetchSavedCities()
    }
    
    /// Возвращает в замыкании массив responce необходимыми для создания view
    func updateResponces() {
        networkManager.downloadWeatherConditionArray(for: savedCities) {
            self.savedResponces = $0
        }
    }
    
}


//MARK: - Table delegate / dataSource
extension CityChooserVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let geo = savedCities[indexPath.row]
        let responce = savedResponces[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, for: indexPath) as! SuggestionCitiesCell
        cell.primaryText = geo.nameOfLocation ?? "nill"
        cell.secondaryText = "\(responce.0.tempAndPressure?.temp ?? -100). \(responce.0.weatherDescription?.first?.description ?? "nil")"
        cell.setupUI()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let geo = savedCities[indexPath.row]
//        let responce = savedResponces[indexPath.row]
//        DataManager.shared.removeIsFirstToShowFlag()
//        DataManager.shared.setIsFirstToShowFlag(geo: geo)
//        delegate?.passResponces(geo, responceTuple: responce)
        // установить в pageVC экран
        // setViewControllers([pages[initialPage]], direction: .forward, animated: true)
      
        let index = indexPath.row
        
        guard let vc = navigationController?.viewControllers[0] as? PageVC else { return }
        vc.setViewControllers([vc.pages[index]], direction: .forward, animated: true)
        
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
            self.savedResponces.remove(at: indexPath.row)
            let cityToDelete = self.savedCities[indexPath.row]
            let cityToDeleteCD = DataManager.shared.convertAndFetch(geo: cityToDelete)
            DataManager.shared.delete(cityToDeleteCD)
            self.savedCities.removeAll { $0.lat == cityToDelete.lat && $0.lon == cityToDelete.lon }
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
        
        let workItem = DispatchWorkItem {
            let cityName = searchController.searchBar.text
            self.networkManager.getCoordinateByCityName(cityName: cityName ?? "") { responces in
                DispatchQueue.main.async {
                    self.resultsTableVC?.responces = responces
                    self.resultsTableVC?.tableView.reloadData()
                }
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: workItem)
    }
}
