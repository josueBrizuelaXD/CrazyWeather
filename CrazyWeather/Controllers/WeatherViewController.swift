//
//  WeatherViewController.swift
//  CrazyWeather
//
//  Created by [JOSH] on 10/11/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var summaryWeatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    
    let apiKey = "082e6533e8dc5235d377971b22a93ce5"
    let apiURL = "https://api.openweathermap.org/data/2.5/weather?lat=29.74&lon=-95.23&appid=082e6533e8dc5235d377971b22a93ce5"
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableBasicLocationServices()
        
    }
    
    func enableBasicLocationServices() {
        locationManager.delegate = self
        
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            // Request when-in-use authorization initially
            locationManager.requestWhenInUseAuthorization()
            break
            
        case .restricted, .denied:
            // Disable location features
            break
            
        case .authorizedWhenInUse:
            // Enable location features
            break
        case .authorizedAlways:
            startReceivingSignificantLocationUpdates()
            break
        }
    }
    
    func startReceivingSignificantLocationUpdates() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            print("significant locations services not enabled")
            return
        }
        
        locationManager.startMonitoringSignificantLocationChanges()
    }
    
    
    func getWeatherResultsFor(latitude: Double, longitude: Double) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string:"https://api.openweathermap.org/data/2.5/weather") {
            urlComponents.query = "lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            guard let url = urlComponents.url else { return }
            print("[JOSH] url: \(url)")
            dataTask = defaultSession.dataTask(with: url) {
                data, response, error in
                defer {
                    self.dataTask = nil
                }
                
                if let error = error {
                    print("[JOSH] error: \(error)")
                    
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    let jsonDict = self.parseJSON(data: data)
                    
                    if let jsonDict = jsonDict {
                        DispatchQueue.main.async {
                            self.updateUIWith(json: jsonDict)
                        }
                    }
                }
            }
            dataTask?.resume()
        }
    }
    
    func updateUIWith(json:[String: Any]) {
        
        guard let cityName = json["name"] as? String else { return }
        //update city label
       self.cityLabel.text = cityName
        
        if let weatherSummary = json["weather"] as? [Any] {
            if let summaryDict = weatherSummary[0] as? [String: Any] {
                //update weather summary label
                if let weatherSum = summaryDict["description"] as? String {
                    
                    let w =  capitalizeSubstrings(from: weatherSum)
                    self.summaryWeatherLabel.text = w
                }
            }
            
        }
        
        if let main = json["main"] as? [String: Any] {
            print("[JOSH] main: \(main)")
            if let temp = main["temp"] as? Double {
                print("[JOSH] temp \(temp)")
                let t = kelvinToFah(k: temp)
                tempLabel.text = String(t) + "º"
            }
        }
        
    }
    
    func capitalizeSubstrings(from string: String) -> String {
        let substrings = string.split(separator: " ")
        var newString = ""
        
        for substring in substrings {
            var capitalizedSubstring = ""
            let firstChar = substring[substring.startIndex]
             let firstLetter = String(firstChar)
            let remainingSubstring = substring[substring.index(after: substring.startIndex)...]
            let upperChar = firstLetter.uppercased()
            capitalizedSubstring = upperChar + remainingSubstring
            newString += capitalizedSubstring + " "
        }
        
        return newString
    }
    
    func parseJSON(data: Data) -> [String: Any]? {
        
        var jsonDict : [String: Any]?
        
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseErr as NSError {
            print("[JOSH] err: \(parseErr)")
        }
        
        if let jsonDict = jsonDict {
            print("[JOSH] json: \(jsonDict)")
            return jsonDict
        }
        
        return nil
    }
    
    func kelvinToCelsius(k:Double) -> Int {
        return Int(round(k - 273.15))
    }
    
    func kelvinToFah(k:Double) -> Int {
        return Int(round((k * 9 / 5) - 459.67))
    }
}

extension WeatherViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            startReceivingSignificantLocationUpdates()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let loc = locations[0]
        let latitude = Double(round(100 * loc.coordinate.latitude) / 100)
        let longitude = Double(round(100 * loc.coordinate.longitude) / 100)
        
        
        
        
        getWeatherResultsFor(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[JOSH] error: \(error)")
    }
}

