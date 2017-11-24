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
    private var token: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        enableBasicLocationServices()
        token = WeatherAPI.shared.observe(\.weather) {
            weatherAPI, v in
            print("[JOSH] o: \(weatherAPI)")
            print("[JOSH] v: \(v)")
            
            DispatchQueue.main.async {
                self.updateWeatherLabelsWith(weatherData: weatherAPI.weather)
            }
            
        }
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
    
    func updateWeatherLabelsWith(weatherData: Weather?) {
        
        guard let weather = weatherData else { return }
        self.cityLabel.text = weather.name
        let w =  capitalizeSubstrings(from: weather.weather[0].summary)
        self.summaryWeatherLabel.text = w
        tempLabel.text = String(Int(weather.main.temp.rounded())) + "º"
        
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
        
        WeatherAPI.shared.getWeatherResultsFor(latitude: latitude, longitude: longitude)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[JOSH] error: \(error)")
    }
}

