//
//  CityChooserVC.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import UIKit

class CityChooserVC: UITableViewController {

    //MARK: Properties
    public var searchController: UISearchController!
    public var geoResponces: [GeoResponce]
    /// Приходит с PageVC как только загрузится
    public var weatherResponceTuples: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]?
    
    private var resultsTableVC: ResultsTableVC?
    private let networkManager = NetworkManager()
    private var searchWorkItem: DispatchWorkItem?
    private var cells: [SuggestionCitiesCell] = []
    private let notificationCenter = NotificationCenter.default
    
    
    //MARK: - Init
    init(geoResponces: [GeoResponce]) {
        self.geoResponces = geoResponces
        super.init(nibName: nil, bundle: nil)
        print("CityChooserVC init 🧐")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        print("CityChooserVC deinit 🧐")
    }
    
    
    //MARK: - View Life Circle
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CityChoser View Did Load 🧐")
        setupUI()
    }
    
    /// Из-за разных фонов WeatherVC и CityChoserVC нужно вручную менять цвет акцента верхнего navigationBar
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navigationController?.navigationBar.tintColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
    }
    

    //MARK: - SetupUI
    private func setupUI() {
        configureSelf()
        configureSearchController()
    }
    
    private func configureSelf() {
        self.view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.navigationItem.title = "Choose city" // поменять на Погода как в эпл погоде
        tableView.register(SuggestionCitiesCell.self, forCellReuseIdentifier: SuggestionCitiesCell.identifier)
        navigationItem.rightBarButtonItem = editBarButtonItem
        
    }
    
    private func configureSearchController() {
        resultsTableVC = ResultsTableVC()
        resultsTableVC?.parentCityChooserVC = self
        searchController = UISearchController(searchResultsController: resultsTableVC)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.tintColor = #colorLiteral(red: 0, green: 0.46, blue: 0.89, alpha: 1)
        searchController.searchResultsUpdater = self
    }

    /// Заполняем массив weatherResponceTuples данными, для отображения погодных условий в ячейках городов
    public func updateWeatherResponces(responceTuples: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]) {
        self.weatherResponceTuples = responceTuples
        self.tableView.reloadData()
    }
    
    
    // MARK: - UIBarButtonItem Creation and Configuration
    /// Включает режим редактирования
    private var editBarButtonItem: UIBarButtonItem {
        let image = UIImage(systemName: "ellipsis.circle")
        return UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(barButtonItemClicked(_:)))
    }
   
    private func deleteRow(indexPath: IndexPath) {
        let cityToDelete = self.geoResponces[indexPath.row]
        let cityToDeleteCD = DataManager.shared.convertAndFetch(geo: cityToDelete)
        
        /// Удаляем элемент из CD и self
        DataManager.shared.delete(cityToDeleteCD)
        self.weatherResponceTuples?.remove(at: indexPath.row)
        self.geoResponces.remove(at: indexPath.row)
        // удалить ячейку из массива
        cells.removeAll(where: { $0.geo.lat == cityToDelete.lat && $0.geo.lon == cityToDelete.lon })
        
        /// Удаляем элемент из PageVC
        if let pageVC = self.navigationController?.viewControllers[0] as? PageVC {
            pageVC.changePageControlPageAmount { $0.numberOfPages -= 1 }
            pageVC.pages.remove(at: indexPath.row)
            
            let index = pageVC.geoResponces.firstIndex(where: { $0.lat == cityToDelete.lat && $0.lon == cityToDelete.lon })
            if let index = index {
                pageVC.geoResponces.remove(at: index)
            }
        } else {
            print("Не удалось привести к PageVC 😨")
        }
        
        self.tableView.reloadData()
    }
    
    // MARK: - @objc
    @objc
    private func barButtonItemClicked(_ sender: UIBarButtonItem) {
        print("barBitton clicked ☮️")
        if tableView.isEditing { // если делалось, то убирает
            print("set editing to false 🈴")
            // функция сохранения индексов
            // по нажатию кнопки идет в старый индекс на pagerVC
            
            print("cells.count == \(cells.count) 🅿️")
            for cell in cells {
                guard let indexPath = tableView.indexPath(for: cell) else {
                    print("cells.count == \(cells.count) 🔶")
                    
                    tableView.setEditing(false, animated: true)
                    return
                }
                DataManager.shared.changeIndex(geo: cell.geo, newIndex: Int16(indexPath.row))
            }
    
            tableView.setEditing(false, animated: true)
            print("seted! editing to false 🈴")
        } else { // если не делалось то делает
            print("set editing to true ❇️")
            tableView.setEditing(true, animated: true)
        }
    }
    
}


//MARK: - Table delegate / dataSource
extension CityChooserVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geoResponces.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: SuggestionCitiesCell.identifier, for: indexPath) as! SuggestionCitiesCell
        let geo = geoResponces[indexPath.row]
        
        cell.primaryText = geo.nameOfLocation ?? "nill"
        cell.geo = geo
        cells.append(cell)
        /// Если показали CityChoserVC до того как скачали погодные условия, то показывает прочерки
        if let responce = weatherResponceTuples?[indexPath.row] {
            cell.secondaryText = "\(responce.0.tempAndPressure?.temp ?? -100). \(responce.0.weatherDescription?.first?.description ?? "nil")"
        } else {
            cell.secondaryText = "- -"
        }
      // когда городов еще не было, тогда ошибка и показывает - -
// после нажатия делет кнопки не снимает режим редактирования

        cell.setupUI()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let pageVC = navigationController?.viewControllers[0] as? PageVC else { return }
        let index = indexPath.row
            
        /// Обновляем PageVC
        pageVC.setViewControllers([pageVC.pages[index]], direction: .forward, animated: false)
        pageVC.updatePageControlCurrentPage(to: index)
        
        /// Устанавливаем isFirstToShow flag
        DataManager.shared.setIsFirstToShowFlag(geo: geoResponces[index])
        self.navigationController?.popToRootViewController(animated: true)
    }

    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // перенести потом в кнопку
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete")
        { action, view, completionHandler in
            self.deleteRow(indexPath: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
    
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        ///Настройка при перемещении ячеек
        print("Moved! 🥶 from \(sourceIndexPath.row) to \(destinationIndexPath.row) 🫡")
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        /// Настройка при удалении ячеек
        deleteRow(indexPath: indexPath)
    }
    
}


//MARK: - Search Updater
extension CityChooserVC: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchWorkItem?.cancel()
        
        /// Поиск координат по текстовому полю
        let workItem = DispatchWorkItem {
            let cityName = searchController.searchBar.text
            self.networkManager.getCoordinateByCityName(cityName: cityName ?? "") { responces in
                DispatchQueue.main.async {
                    self.resultsTableVC?.geoResponces = responces
                    self.resultsTableVC?.tableView.reloadData()
                }
            }
        }
        
        searchWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25, execute: workItem)
    }
}
