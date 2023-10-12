//
//  ResultsTableVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 07.08.2023.
//

import UIKit

class ResultsTableVC: UITableViewController {

    //MARK: Properties
    internal var searchResults: [GeoResponce] = []
    
    /// Передастся в ModalVC для сохранения города в CD
    internal let index: Int
    
    
    //MARK: - Init
    init(index: Int) {
        self.index = index
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
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
