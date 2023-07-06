//
//  NetworkManager.swift
//  Weather
//
//  Created by Арсений Кухарев on 06.07.2023.
//

import Foundation

class NetworkManager {
    
    func getWeather(coord: Coord, _ completionHandler: @escaping (WeatherResponce) -> Void) {
        let apiKey = "d1a7dc287df5a60b293bf2ac933cbf13"
        let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(coord.lat)&lon=\(coord.lon)&units=metric&appid=\(apiKey)")
        guard let url = url else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else { return }
            
            if let httpResponce = response as? HTTPURLResponse {
                let decode: WeatherResponce = try! JSONDecoder().decode(WeatherResponce.self, from: data!)
                completionHandler(decode)
            }
        }
        task.resume()
        
    }
}
