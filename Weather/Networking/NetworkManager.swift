//
//  NetworkManager.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

class NetworkManager {
    
    let apiKey = ApiKey.apiKey
    
    func getWeather(for coord: Coordinates, _ completionHandler: @escaping (WeatherResponce) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coord.lat)&lon=\(coord.lon)&units=metric&appid=\(apiKey)")
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            
            if response is HTTPURLResponse {
                do {
                    print(String(data: data, encoding: .utf8))
                    let decode: WeatherResponce = try JSONDecoder().decode(WeatherResponce.self, from: data)
                    completionHandler(decode)
                } catch {
                    print(error.localizedDescription)
                    print("Не удалось распарсить JSON(")
                    // уведомление что не получилось распарсить
                }
            }
        }
        task.resume()
    }
    
    
    func getCoordinateByCityName(cityName: String, _ completionHandler: @escaping ([GeoResponce]) -> Void) {
        let stringUrl = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=10&appid=\(apiKey)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
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
                    print(error.localizedDescription)
                    print("Не удалось распарсить JSON(")
                    // уведомление что не получилось распарсить
                }
            }
        }
        task.resume()
    }
}
