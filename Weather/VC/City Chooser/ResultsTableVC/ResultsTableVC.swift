//
//  ResultsTableVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 07.08.2023.
//

import UIKit

class ResultsTableVC: UITableViewController {

    //MARK: Properties
    public var parentCityChooserVC: CityChooserVC! // зачем тут нужен вообще?
    internal var searchResults: [GeoResponce] = []
    
    
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
        tableView.register(SuggestionCitiesCell.self,
                           forCellReuseIdentifier: SuggestionCitiesCell.identifier)
    }

    public func fillGeoResponces(with data: [GeoResponce]) {
        self.searchResults = data
    }
    
}
