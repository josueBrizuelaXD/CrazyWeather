//
//  APIService.swift
//  CrazyWeather
//
//  Created by Josh on 11/22/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import Foundation

struct WeatherAPI {
    static var shared = WeatherAPI ()
    
    let apiKey = "082e6533e8dc5235d377971b22a93ce5"
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    
    mutating  func getWeatherResultsFor(latitude: Double, longitude: Double, completion:  @escaping (Data?) -> Void) {
        
        if var urlComponents = URLComponents(string:"https://api.openweathermap.org/data/2.5/weather") {
            urlComponents.query = "lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            guard let url = urlComponents.url else { return }
            print("[JOSH] url: \(url)")
            
            getData(url: url, completion: completion)
        }
    }
    
    mutating func getForecastResultsFor(latitude: Double, longitude: Double, completion: @escaping (Data?) -> Void) {
        
        if var urlComponents = URLComponents(string:"https://api.openweathermap.org/data/2.5/forecast") {
            urlComponents.query = "lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            guard let url = urlComponents.url else { return }
            print("[JOSH] url: \(url)")
            
            getData(url: url, completion: completion)
        }
        
    }
    
  mutating func getData(url: URL, completion: @escaping (Data?) -> Void) {
        dataTask?.cancel()
    
        dataTask = defaultSession.dataTask(with: url) {
            data, response, error in
            defer {
                self.dataTask = nil
            }
            
            if let error = error {
                print("[JOSH] error: \(error)")
                
            } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                print("[JOSH] data: \(data)")
                completion(data)
            }
        }
        dataTask?.resume()
    }
    
    func parseJSON(data: Data?) -> [String: Any]? {
        
        guard let data = data else { return nil }
        
        var jsonDict : [String: Any]?
        
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseErr as NSError {
            print("[JOSH] err: \(parseErr)")
        }
        
        if let jsonDict = jsonDict {
            return jsonDict
        }
        
        return nil
    }
    
}
