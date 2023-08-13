//
//  ResultsTableVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 07.08.2023.
//

import UIKit

class ResultsTableVC: UITableViewController {

    //MARK: Properties
    var responces: [GeoResponce] = []
    weak var delegate: CityChooserDelegate?
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
    }
    
    private func configureSelf() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.register(SuggestionCitiesCell.self, forCellReuseIdentifier: SuggestionCitiesCell.identifier)
    }
    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return responces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, for: indexPath) as! SuggestionCitiesCell
        cell.primaryText = responces[indexPath.row].nameOfLocation ?? "nil"
        cell.secondaryText = "\(responces[indexPath.row].state ?? "nil"). \(responces[indexPath.row].country ?? "nil")"
        cell.setupUI()
        return cell
    }

    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.passGeoResponce(responces[indexPath.row])
        let vc = WeatherVC(geoResponce: responces[indexPath.row], isModal: true)
        let navVC = UINavigationController(rootViewController: vc)
        present(navVC, animated: true)
    }
    
}
