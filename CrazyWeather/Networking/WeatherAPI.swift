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
    @objc dynamic private(set) var weather: Weather?
    @objc dynamic private(set) var forecast: Forecast?
    
    private enum API {
        
        case currentWeather
        case currentForecast
        
        fileprivate func path() -> URLComponents {
            switch self {
            case .currentWeather:
                return URLComponents(string:"\(WeatherAPI.basePath)weather")!
            case .currentForecast:
                return URLComponents(string:"\(WeatherAPI.basePath)forecast")!
            }
        }
    }
    
    func getWeatherResultsFor(latitude: Double, longitude: Double) {
        
        var urlComponents = API.currentWeather.path()
        urlComponents.query = "lat=\(latitude)&lon=\(longitude)&appid=\(SecretKeys.weatherKey)&units=imperial"
        guard let url = urlComponents.url else { return }
        print("[JOSH] url: \(url)")
        
        fetch(url: url) {
            data in
            //            print("[JOSH] data: \(data!)")
            do {
                let weather = try JSONDecoder().decode(Weather.self, from:data!)
                //                print("[JOSH] weather: \(weather)")
                self.weather =  weather
            } catch let error {
                print("[JOSH] \(error)")
            }
        }
    }
    
    func getIcon(name: String,  completion: @escaping (Data?)->(Void)) {
        
        let urlStr = "https://openweathermap.org/img/w/" + name + ".png"
        let url = URL(string: urlStr)
        if let url = url {
            fetch(url:url , completion: completion)
        }
        
    }
    
    func getForecastResultsFor(latitude: Double, longitude: Double) {
        
        var urlComponents = API.currentForecast.path()
        urlComponents.query = "lat=\(latitude)&lon=\(longitude)&appid=\(SecretKeys.weatherKey)&units=imperial"
        guard let url = urlComponents.url else { return }
        
        
        fetch(url: url) {
            data in
            
            do {
                let forecast = try JSONDecoder().decode(Forecast.self, from:data!)
                self.forecast =  forecast
            } catch let error {
                print("[JOSH] \(error)")
            }
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

