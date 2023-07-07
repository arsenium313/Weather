//
//  ViewController.swift
//  Weather
//
//  Created by Арсений Кухарев on 05.07.2023.
//

import UIKit

class WeatherVC: UIViewController {

    //MARK: Properties
    private var cityNameLabel: UILabel!
    private var currentTemperatureLabel: UILabel!
    private var currentWeatherIconImageView: UIImageView!
    private var currentWeatherColorView: UIView!
    private var nameAndTemperatureStackView: UIStackView!
    private var iconAndColorStackView: UIStackView!
    private var goToCityChooserButton: UIBarButtonItem!
    
    private lazy var guide = self.view.layoutMarginsGuide
    
    private let networkManager = NetworkManager()
    private var weatherResponce: WeatherResponce!
    
    //MARK: - VIew Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    
    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureCityNameLabel()
        configureCurrentTemperatureLabel()
        configureNameAndTemperatureStackView()
        configureCurrentWeatherIconImageView()
        configureCurrentWeatherColorView()
        configureIconAndColorStackView()
        configureGoToChooserButtonItem()
    }
    
    private func configureSelf() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "Weather"
        
        networkManager.getWeather(coord: Coord(lon: 52.43, lat: 30.97)) { weatherResponce in
            DispatchQueue.main.async {
                self.weatherResponce = weatherResponce
                self.cityNameLabel.text = weatherResponce.name
                self.currentTemperatureLabel.text = String(weatherResponce.main.temp)
                self.currentWeatherColorView.backgroundColor = UIColor.getTemperatureColor(Cº: weatherResponce.main.temp)
            }
        }
    }
    
    private func configureCityNameLabel() {
        cityNameLabel = UILabel()
        cityNameLabel.text = "-"
    }
    
    private func configureCurrentTemperatureLabel() {
        currentTemperatureLabel = UILabel()
        currentTemperatureLabel.text = "-"
    }
    
    private func configureCurrentWeatherIconImageView() {
        let icon = UIImage(named: "15")
        currentWeatherIconImageView = UIImageView(image: icon)
    }
    
    private func configureCurrentWeatherColorView() {
        currentWeatherColorView = UIView()
        currentWeatherColorView.backgroundColor = UIColor.getTemperatureColor(Cº: 0)
        currentWeatherColorView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureNameAndTemperatureStackView() {
        let arrSub: [UIView] = [cityNameLabel, currentTemperatureLabel]
        nameAndTemperatureStackView = UIStackView(arrangedSubviews: arrSub)
        nameAndTemperatureStackView.axis = .vertical
        nameAndTemperatureStackView.alignment = .center
        nameAndTemperatureStackView.distribution = .fillEqually
        nameAndTemperatureStackView.spacing = 10
        nameAndTemperatureStackView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        nameAndTemperatureStackView.layer.cornerRadius = 8
        nameAndTemperatureStackView.layer.borderWidth = 1
        nameAndTemperatureStackView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(nameAndTemperatureStackView)
        nameAndTemperatureStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            nameAndTemperatureStackView.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            nameAndTemperatureStackView.trailingAnchor.constraint(equalTo: guide.trailingAnchor),
            nameAndTemperatureStackView.topAnchor.constraint(equalTo: guide.topAnchor),
            nameAndTemperatureStackView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.15)
        ])
    }
    
    private func configureIconAndColorStackView() {
        let arrSub: [UIView] = [currentWeatherIconImageView, currentWeatherColorView]
        iconAndColorStackView = UIStackView(arrangedSubviews: arrSub)
        iconAndColorStackView.axis = .horizontal
        iconAndColorStackView.alignment = .fill
        iconAndColorStackView.distribution = .fillEqually
        iconAndColorStackView.spacing = 0
        iconAndColorStackView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        iconAndColorStackView.layer.cornerRadius = 8
        iconAndColorStackView.layer.borderWidth = 1
        iconAndColorStackView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        self.view.addSubview(iconAndColorStackView)
        iconAndColorStackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            iconAndColorStackView.topAnchor.constraint(equalTo: nameAndTemperatureStackView.bottomAnchor,constant: 20),
            iconAndColorStackView.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
            iconAndColorStackView.widthAnchor.constraint(equalTo: guide.widthAnchor, multiplier: 0.7),
            iconAndColorStackView.heightAnchor.constraint(equalTo: guide.heightAnchor, multiplier: 0.15)
        ])
    }
    
    private func configureGoToChooserButtonItem() {
        goToCityChooserButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(goToCityChooserVC))
        self.navigationItem.rightBarButtonItem = goToCityChooserButton
    }
    
    //MARK: - Selectors
    @objc
    private func goToCityChooserVC() {
        let vc = CityChooserVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

