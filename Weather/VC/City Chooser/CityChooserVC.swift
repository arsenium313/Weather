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
    
    func updateSavedCiries() {
        savedCities = DataManager.shared.fetchSavedCities()
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
        delegate?.passGeoResponce(savedCities[indexPath.row])
        self.navigationController?.popToRootViewController(animated: true)
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
