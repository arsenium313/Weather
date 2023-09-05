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
    
    /// Скачиваем погодные условия для указанных координат и обновляем указанный BundleView
    public func downloadAndSetupUI(_ coordinates: Coordinates, forView bundleView: BundleView) {
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
            bundleView.setupUI(using: weatherResponce, airQualityResponce)
        }
    }
    
}
