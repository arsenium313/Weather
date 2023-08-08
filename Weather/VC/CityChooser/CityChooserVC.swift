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
    private var geoResponces: [GeoResponce] = []
    private let networkManager = NetworkManager()

    weak var delegate: CityChooserDelegate?
    
    private let savedCities = [GeoResponce(nameOfLocation: "Гомель", localizedNames: nil, lat: 52.36, lon: 31, country: "РБ", state: "Гомельская область"),
                               GeoResponce(nameOfLocation: "Тель-Авив", localizedNames: nil, lat: 32.04, lon: 34.46, country: "Израиль", state: "nil"),
                               GeoResponce(nameOfLocation: "Санкт-Петербург", localizedNames: nil, lat: 59.9, lon: 30.3, country: "РФ", state: "Ленинградская область")]
    
    private var searchController: UISearchController!
    private var resultController: ResultsTableVC!
    
    
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
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
        searchController.searchBar.searchBarStyle = .minimal
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        
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
