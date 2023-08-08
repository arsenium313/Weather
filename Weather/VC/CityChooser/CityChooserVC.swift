//
//  CityChooserVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import UIKit

class CityChooserVC: UITableViewController {

    //MARK: Properties
    private lazy var guide = self.view.layoutMarginsGuide
   // private var geoResponces: [GeoResponce] = []
    private let networkManager = NetworkManager()

    weak var delegate: CityChooserDelegate?
    var savedCities = PublicGeoArray().savedCities
    private var searchController: UISearchController!
    var resultController: ResultsTableVC?
    
    private var searchWorkItem: DispatchWorkItem?
    
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

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
        self.navigationItem.title = "Choose city"
        tableView.register(SuggestionCitiesCell.self, forCellReuseIdentifier: SuggestionCitiesCell.identifier)
    }
    
    private func configureSearchController() {
        resultController = ResultsTableVC()
        searchController = UISearchController(searchResultsController: resultController)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        searchController.searchResultsUpdater = self
    }

}


//MARK: - Table delegate / dataSource
extension CityChooserVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedCities.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, for: indexPath) as! SuggestionCitiesCell
        cell.primaryText = savedCities[indexPath.row].nameOfLocation ?? "nill"
        cell.secondaryText = "\(savedCities[indexPath.row].state ?? "nil"). \(savedCities[indexPath.row].country ?? "nil")"
        cell.setupUI()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.passGeoResponce(savedCities[indexPath.row])
        self.navigationController?.popViewController(animated: true)
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
                    self.resultController?.responces = responces
                    self.resultController?.tableView.reloadData()
                }
            }
        }
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: workItem)
    }
}
