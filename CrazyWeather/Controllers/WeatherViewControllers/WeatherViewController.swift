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
    
    let locationManager = CLLocationManager()
    static let forecastNotification = Notification.Name("ForecastNotification")
    
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
    
    

    
    //MARK: - Update UI Elements
    
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
    
    //MARK: - Helper Methods
    
    
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
        
        
        
        
        WeatherAPI.shared.getWeatherResultsFor(latitude: latitude, longitude: longitude, completion: {
            data in
            let jsonDict = WeatherAPI.shared.parseJSON(data: data)
            if let jsonDict = jsonDict {
                DispatchQueue.main.async {
                    self.updateUIWith(json: jsonDict)
                }
            }
            
            WeatherAPI.shared.getForecastResultsFor(latitude: latitude, longitude: longitude) {
                data in
                let jsonDict = WeatherAPI.shared.parseJSON(data: data)
                if let jsonDict = jsonDict {
                    NotificationCenter.default.post(name: WeatherViewController.forecastNotification, object: nil, userInfo: jsonDict)
                }
            }
        })
            
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[JOSH] error: \(error)")
    }
}

