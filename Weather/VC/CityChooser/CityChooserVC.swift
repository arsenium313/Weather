//
//  CityChooserVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import UIKit

class CityChooserVC: UIViewController {

    //MARK: Properties
    private lazy var guide = self.view.layoutMarginsGuide
    private var geoResponces: [GeoResponce] = []
    private let networkManager = NetworkManager()
    private var cityInputTF: UITextField!
    private var citySuggestionTable: UITableView!
    weak var delegate: CityChooserDelegate?
    
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureCityInputTF()
        configureSuggestionTable()
    }
    
    private func configureSelf() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "Choose city"
    }
    
    private func configureCityInputTF() {
        cityInputTF = UITextField()
        cityInputTF.delegate = self
        cityInputTF.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cityInputTF.borderStyle = .roundedRect
        cityInputTF.keyboardType = .default
        cityInputTF.returnKeyType = .search
        
        self.view.addSubview(cityInputTF)
        cityInputTF.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            cityInputTF.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            cityInputTF.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            cityInputTF.topAnchor.constraint(equalTo: guide.topAnchor),
            cityInputTF.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    private func configureSuggestionTable() {
        citySuggestionTable = UITableView()
        self.view.addSubview(citySuggestionTable)
        citySuggestionTable.delegate = self
        citySuggestionTable.dataSource = self
        citySuggestionTable.register(SuggestionCitiesCell.self, forCellReuseIdentifier: SuggestionCitiesCell.identifier)
        citySuggestionTable.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        citySuggestionTable.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            citySuggestionTable.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            citySuggestionTable.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            citySuggestionTable.topAnchor.constraint(equalTo: cityInputTF.bottomAnchor, constant: 15),
            citySuggestionTable.bottomAnchor.constraint(equalTo: guide.bottomAnchor)
        ])
        
    }
    
}


//MARK: - TF Delegate
extension CityChooserVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let userInput = textField.text else { return true }
        networkManager.getCoordinateByCityName(cityName: userInput) { responces in
            self.geoResponces = responces
            DispatchQueue.main.async {
                self.citySuggestionTable.reloadData()
            }
        }
        // запуск кольца ожидания
        textField.resignFirstResponder()
        return true
    }
}

//MARK: - Table delegate / dataSource
extension CityChooserVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoResponces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, for: indexPath) as! SuggestionCitiesCell
        cell.primaryText = geoResponces[indexPath.row].nameOfLocation ?? "nill"
        cell.secondaryText = geoResponces[indexPath.row].state ?? "nill"
        cell.setupUI()
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.passGeoResponce(geoResponces[indexPath.row])
        self.navigationController?.popViewController(animated: true)
    }
    
}
