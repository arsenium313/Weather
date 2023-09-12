//
//  ResultsTableVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 07.08.2023.
//

import UIKit

class ResultsTableVC: UITableViewController {

    //MARK: Properties
    public var geoResponces: [GeoResponce] = []
    public var parentCityChooserVC: CityChooserVC!
    
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        print("ResultsVC init ✅")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("ResultVC deinit ❌")
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
    }
    
    private func configureSelf() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        tableView.register(SuggestionCitiesCell.self, forCellReuseIdentifier: SuggestionCitiesCell.identifier)
    }

    
    // MARK: - TableView DataSource
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoResponces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let geo = geoResponces[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, for: indexPath) as! SuggestionCitiesCell
        cell.primaryText = geo.nameOfLocation ?? "–"
        cell.secondaryText = "\(geo.state ?? "–"). \(geo.country ?? "–")"
        cell.setupUI()
        return cell
    }

    
    // MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let geo = geoResponces[indexPath.row]
        let modalVC = WeatherModalVC(geoResponce: geo, cityChoserVC: parentCityChooserVC)
        let navigationVC = UINavigationController(rootViewController: modalVC)
        present(navigationVC, animated: true)
    }
}
