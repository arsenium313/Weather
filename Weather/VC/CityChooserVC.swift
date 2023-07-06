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
    private var cityInputTF: UITextField!
    private var citySuggestionTable: UITableView!

    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureCityInputTF()
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
}

//MARK: - TF Delegate
extension CityChooserVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
