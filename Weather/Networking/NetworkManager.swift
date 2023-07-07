//
//  NetworkManager.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

class NetworkManager {
    
    let apiKey = "d1a7dc287df5a60b293bf2ac933cbf13"
    
    func getWeather(coord: Coord, _ completionHandler: @escaping (WeatherResponce) -> Void) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coord.lat)&lon=\(coord.lon)&units=metric&appid=\(apiKey)")
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            guard let data = data else { return }
            
            if response is HTTPURLResponse {
                let decode: WeatherResponce = try! JSONDecoder().decode(WeatherResponce.self, from: data)
                completionHandler(decode)
            }
        }
        task.resume()
    }
    
    
    func getCoordinateByName(cityName: String, _ completionHandler: @escaping ([GeoResponce]) -> Void) {
        let stringUrl = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=5&appid=\(apiKey)".addingPercentEncoding(withAllowedCharacters: NSCharacterSet.urlQueryAllowed)
        let url = URL(string: stringUrl ?? "")
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, responce, error in
            guard error == nil else { return }
            guard let data = data else { return }
  
            if responce is HTTPURLResponse {
                let decode: [GeoResponce] = try! JSONDecoder().decode([GeoResponce].self, from: data)
                completionHandler(decode)
            }
        }
        task.resume()
    }
}
