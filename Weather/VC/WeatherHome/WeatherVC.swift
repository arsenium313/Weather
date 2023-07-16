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
    private var geoResponce: GeoResponce!
    
    //MARK: - Init
    init() {
        super.init(nibName: nil, bundle: nil)
        let coor = Coordinates(lon: 52, lat: 31)
        networkManager.getWeather(for: coor) { responce in
            self.weatherResponce = responce
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - View Life Circle
    override func loadView() {
        let view = RootView()
        self.view = view
    }
    
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
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationItem.title = "Weather"
    }
    
    private func configureCityNameLabel() {
        cityNameLabel = UILabel()
    }
    
    private func configureCurrentTemperatureLabel() {
        currentTemperatureLabel = UILabel()
        currentTemperatureLabel.text = "--"
    }
    
    private func configureCurrentWeatherIconImageView() {
        let icon = UIImage(named: "1")
        currentWeatherIconImageView = UIImageView(image: icon)
        currentWeatherIconImageView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: - Get weather and update UI
    private func getWeather(geo: GeoResponce) {
 
    }
    
    
}


//MARK: - Protocols
extension WeatherVC: CityChooserDelegate {
    /// Получаем информацию о геопозиции искомого города
    func passGeoResponce(_ geo: GeoResponce) { //принимаем информацию о геопозиции искомого города
        self.geoResponce = geo
        networkManager.getWeather(for: Coordinates(lon: geo.lon, lat: geo.lat)) { weatherResponce in
            DispatchQueue.main.async {
                self.weatherResponce = weatherResponce
                self.cityNameLabel.text = geo.localizedNames?.en
                self.currentTemperatureLabel.text = String(weatherResponce.tempAndPressure!.temp!)
                self.currentWeatherColorView.backgroundColor = UIColor.getTemperatureColor(Cº: weatherResponce.tempAndPressure!.temp!)
              
            }
            DispatchQueue.global(qos: .userInitiated).async {
                let url = URL(string: "https://openweathermap.org/img/wn/\(weatherResponce.weatherDescription!.first!.iconId!)@2x.png")
                let data = try? Data(contentsOf: url!)
                DispatchQueue.main.async {
                    self.currentWeatherIconImageView.image = UIImage(data: data!)
                }
            }
        }
    }
    
    
    
    
}
