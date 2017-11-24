//
//  APIService.swift
//  CrazyWeather
//
//  Created by Josh on 11/22/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import Foundation

class WeatherAPI: NSObject {
    static let shared = WeatherAPI ()
    private static let basePath = "https://api.openweathermap.org/data/2.5/"
    private static let apiKey = "082e6533e8dc5235d377971b22a93ce5"
    @objc dynamic private(set) var weather: Weather?
    private(set) var forecast: [Forecast] = []
    
    private enum API {
        
        case currentWeather
        case weatherForecast
        
        fileprivate func path() -> URLComponents {
            switch self {
            case .currentWeather:
                return URLComponents(string:"\(WeatherAPI.basePath)weather")!
            case .weatherForecast:
                return URLComponents(string:"\(WeatherAPI.basePath)forecast")!
            }
        }
    }
    
    func getWeatherResultsFor(latitude: Double, longitude: Double) {
        
        var urlComponents = API.currentWeather.path()
        urlComponents.query = "lat=\(latitude)&lon=\(longitude)&appid=\(WeatherAPI.apiKey)&units=imperial"
        guard let url = urlComponents.url else { return }
        print("[JOSH] url: \(url)")
        
        fetch(url: url) {
            data in
            print("[JOSH] data: \(data!)")
            do {
                let weather = try JSONDecoder().decode(Weather.self, from:data!)
                print("[JOSH] weather: \(weather)")
                self.weather =  weather
            } catch let error {
                print("[JOSH] \(error)")
            }
        }
    }
    
    
    
    func getForecastResultsFor(latitude: Double, longitude: Double) {
        
        var urlComponents = API.weatherForecast.path()
        urlComponents.query = "lat=\(latitude)&lon=\(longitude)&appid=\(WeatherAPI.apiKey)&units=imperial"
        guard let url = urlComponents.url else { return }
        print("[JOSH] url: \(url)")
        
        fetch(url: url) {
            data in
            
        }
        
    }
    
    func fetch(url: URL, completion: @escaping (Data?) -> Void) {
        let defaultSession = URLSession(configuration: .default)
        
        
        let dataTask = defaultSession.dataTask(with: url) {
            data, response, error in
            
            guard let data = data, error == nil else { return }
            completion(data)
            
        }
        dataTask.resume()
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

