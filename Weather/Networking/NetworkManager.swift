//
//  NetworkManager.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

class NetworkManager {
    
    let apiKey = ApiKeys.openWeatherApiKey
  
    public func getWeather(for coord: Coordinates, _ completionHandler: @escaping (OpenWeatherResponce) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coord.lat)&lon=\(coord.lon)&units=metric&appid=\(ApiKeys.openWeatherApiKey)")
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            
            if response is HTTPURLResponse {
                do {
                    let decode: OpenWeatherResponce = try JSONDecoder().decode(OpenWeatherResponce.self, from: data)
                    completionHandler(decode)
                } catch {
                 //   print(error.localizedDescription)
                    print("Не удалось распарсить JSON 🙁")
                    // уведомление что не получилось распарсить
                }
            }
        }
        task.resume()
    }
    
    public func getAirPollution(for coord: Coordinates, _ completionHandler: @escaping (OpenWeatherAirPollutionResponce) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(coord.lat)&lon=\(coord.lon)&appid=\(ApiKeys.openWeatherApiKey)")
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            guard error == nil else { return }
            guard let data = data else { return }
     
            if responce is HTTPURLResponse {
                do {
                    let decode: OpenWeatherAirPollutionResponce = try JSONDecoder().decode(OpenWeatherAirPollutionResponce.self, from: data)
                    completionHandler(decode)
                } catch {
                 //   print(error.localizedDescription)
                    print("Не удалось распарсить JSON 🙁")
                    // уведомление что не получилось распарсить
                }
            }
        }
        task.resume()
    }
    
    public func getCoordinateByCityName(cityName: String, _ completionHandler: @escaping ([GeoResponce]) -> Void) {
        let stringUrl = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=20&appid=\(apiKey)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: stringUrl ?? "")
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            guard error == nil else { return }
            guard let data = data else { return }
  
            if responce is HTTPURLResponse {
                do {
                    let decode: [GeoResponce] = try JSONDecoder().decode([GeoResponce].self, from: data)
                    completionHandler(decode)
                } catch {
                  //  print(error.localizedDescription)
                    print("Не удалось распарсить JSON ☹️")
                    // уведомление что не получилось распарсить
                }
            }
        }
        task.resume()
    }
    
    // MARK: - Download from GeoResponce
    /**
     Скачиваем погодные условия для указанных координат их в кортеже
     - Parameter for: GeoResponce для которого нужно скачать погодные условия
     - Returns completionHandler:  скачанный responce
     */
    public func downloadWeatherCondition(for geo: GeoResponce, _ completionHandler: @escaping ((OpenWeatherResponce, OpenWeatherAirPollutionResponce )) -> Void) {
        let coordinates = Coordinates(lon: geo.lon, lat: geo.lat)
        var weatherResponce: OpenWeatherResponce!
        var airQualityResponce: OpenWeatherAirPollutionResponce!
        let dispatchGroup = DispatchGroup()
        
        dispatchGroup.enter()
        getWeather(for: coordinates) { responce in
            weatherResponce = responce
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        getAirPollution(for: coordinates) { responce in
            airQualityResponce = responce
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            completionHandler((weatherResponce, airQualityResponce))
        }
    }
    
    
    /**
     Скачиваем погодные условия для указанных координат и возвращаем их в отсортированном массиве
     Если geo пуст, то выйдет из вызывающего замыкания
     - Parameter for: Массив GeoResponce для которого нужно скачать погодные условия
     - Returns completionHandler: Массив скачанных responce
     - Note: Используется для обновления погодных условий сразу на всех городах
     */
    public func downloadWeatherConditionArray(for geo: [GeoResponce],
                                              _ completionHandler: @escaping ([(OpenWeatherResponce, OpenWeatherAirPollutionResponce)]) -> Void) {
        guard !geo.isEmpty else { return }
        var responces: [(OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = []
        var responceWithSortIndex: [(Int, OpenWeatherResponce, OpenWeatherAirPollutionResponce)] = []
        let outerGroup = DispatchGroup()
        
        for (i, geo) in geo.enumerated() {
            outerGroup.enter()
            let coordinates = Coordinates(lon: geo.lon, lat: geo.lat)
            var weatherResponce: OpenWeatherResponce!
            var airQualityResponce: OpenWeatherAirPollutionResponce!
            let innerGroup = DispatchGroup()
           
            innerGroup.enter()
            self.getWeather(for: coordinates) { responce in
                weatherResponce = responce
                innerGroup.leave()
            }
            
            innerGroup.enter()
            self.getAirPollution(for: coordinates) { responce in
                airQualityResponce = responce
                innerGroup.leave()
            }
            
            innerGroup.notify(queue: .global()) {
                responceWithSortIndex.append((i, weatherResponce, airQualityResponce))
                outerGroup.leave()
            }
        }
        
        /// Вызов когда скачаны погодные условия для всего входящего массива GeoResponce
        outerGroup.notify(queue: .main) {
            /**
             Порядок входящего массива geo это порядок в котором нужно отображать WeatherHomeVC в PageController и порядок ячеек таблицы в CityChooserVC
             т.к innerGroup.notify происходит в порядке скачивания погодных условий, а не порядке цикла, нужно вручную сортировать возвращаемый массив
             для этого создаем еще один массив с индексом, сортируем по нему и добавляем элементы в возвращаемый массив responce
             */
            responceWithSortIndex.sort(by: { $0.0 < $1.0 })
            responceWithSortIndex.forEach { responces.append(($1,$2)) }
            
            completionHandler(responces)
        }
    }
    
    
}
