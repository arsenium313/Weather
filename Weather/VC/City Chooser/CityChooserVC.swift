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
    
    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        print("City Chooser init")
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
        updateSavedCiries()
        configureSelf()
        configureSearchController()
    }
    
    private func configureSelf() {
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
    
    /// Обновляет таблицу скачивая из CD все объекты 
    func updateSavedCiries() {
        savedCities = DataManager.shared.fetchSavedCities()
        tableView.reloadData()
    }
    
}


//MARK: - Table delegate / dataSource
extension CityChooserVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let geo = savedCities[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, for: indexPath) as! SuggestionCitiesCell
        cell.primaryText = geo.nameOfLocation ?? "nill"
        cell.secondaryText = "\(geo.state ?? "nil"). \(geo.country ?? "nil")"
        cell.setupUI()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let geo = savedCities[indexPath.row]
        // меняет в CD объект и добавляет ему флаг "первый" убирает флаг со всех остальных
        
        // фетч только тех что с флагом, менять фдлги и сохранять
        // фетч два - один уже с флагом и один которы по лат и лон сходится с (savedCities[indexPath.row])
        // func convertAndFetch(geo: GeoResponce) -> GeoResponceCD?  найти ту что нужно флаг поменять
        
        // снимаем флаг у прошлого нажатого
        DataManager.shared.removeIsFirstToShowFlag()
        
        // меняем флаг у нажатого
        let cd = DataManager.shared.convertAndFetch(geo: geo)
        cd?.isFirstToShow = true
        print("\(cd?.nameOfLocation) is now showing first")
        DataManager.shared.saveContext()
        
        
        delegate?.passGeoResponce(geo)
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { action, view, completionHandler in
       
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
