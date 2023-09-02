//
//  ResultsTableVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 07.08.2023.
//

import UIKit

class ResultsTableVC: UITableViewController {

    //MARK: Properties
    public var responces: [GeoResponce] = []
    public var parentTest: CityChooserVC!
    
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        print("Results VC init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("resultVC deinit")
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
        return responces.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let geo = responces[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, for: indexPath) as! SuggestionCitiesCell
        cell.primaryText = geo.nameOfLocation ?? "nil"
        cell.secondaryText = "\(geo.state ?? "nil"). \(geo.country ?? "nil")"
        cell.setupUI()
        return cell
    }

    
    //MARK: - TableView Delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let geo = responces[indexPath.row]
        let vc = WeatherModalVC(geoResponce: geo, cityChoserVC: parentTest)
        let navigationVC = UINavigationController(rootViewController: vc)
        present(navigationVC, animated: true)
    }
}
