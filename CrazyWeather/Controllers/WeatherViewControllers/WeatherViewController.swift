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
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var summaryWeatherLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    let locationManager = CLLocationManager()
    private var token: NSKeyValueObservation?
    
    
    //weather-backgrounds
    private enum WeatherBackgrounds: String {
        case clear = "sunny-landscape"
        case snow = "snow-landscape"
        case rain = "rain-landscape"
        case afternoon = "afternoon-landscape"
        case night = "night-landscape"
    }
    
    
    //MARK: - View Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Add a refreshControl to scrollview
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(WeatherViewController.refreshContents), for: .valueChanged)
        scrollView.refreshControl = refreshControl
        
        //add viewcontroller as the delegate of the locationManager
        locationManager.delegate = self
        
        //request user authorization and enable location services
        enableBasicLocationServices()
        
        //Observe changes in the Weather property
        token = WeatherAPI.shared.observe(\.weather) {
            weatherAPI, v in
            
            
            //update UI
            DispatchQueue.main.async {
                
                //if there's a refresh control and is refreshing, stop it.
                if let refreshControl = self.scrollView.refreshControl, refreshControl.isRefreshing {
                    refreshControl.endRefreshing()
                }
                self.updateWeatherViewsWith(weatherData: weatherAPI.weather)
                self.locationManager.stopMonitoringSignificantLocationChanges()
            }
            
        }
    }
    
    //MARK: - CoreLocation
    
    func enableBasicLocationServices() {
        
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
            startReceivingSignificantLocationUpdates()
            break
        case .authorizedAlways:
            
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
    
    func updateWeatherViewsWith(weatherData: Weather?) {
        
        guard let weather = weatherData else { return }
        self.cityLabel.text = weather.name
        let w =  capitalizeSubstrings(from: weather.weather[0].summary)
        self.summaryWeatherLabel.text = w
        tempLabel.text = String(Int(weather.main.temp.rounded())) + "º"
        
        if let image = self.updateBackgroundWith(image: weather.weather[0].summary, time:weather.dt) {
            
            UIView.animate(withDuration: 0.8, delay: 0.0, options: [.curveEaseIn], animations: {
                self.backgroundImage.alpha = 0.0
                
            }, completion: {
                completed in
                
                UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
                    self.backgroundImage.image = image
                    self.backgroundImage.alpha = 1.0
                })
            })
            
        }
        
    }
    
    //MARK: - Helper Methods
    @objc private func refreshContents() {
        //if we have a recent location use it to make a new request.
        
        if let location = locationManager.location {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            WeatherAPI.shared.getWeatherResultsFor(latitude: latitude, longitude: longitude)
            WeatherAPI.shared.getForecastResultsFor(latitude: latitude, longitude: longitude)
            //else request new user location
        } else {
            enableBasicLocationServices()
        }
    }
    
    
    private func updateBackgroundWith(image: String, time: Int?) -> UIImage? {
        
        var weatherImage : WeatherBackgrounds = WeatherBackgrounds.clear
        
        switch image {
        case "Snow":
            weatherImage = WeatherBackgrounds.snow
        case "Rain":
            weatherImage = WeatherBackgrounds.rain
            
        default:
            
            if let time = time {
                let date = Date(timeIntervalSince1970: TimeInterval(time))
                let calendar = Calendar.current
                let dateComponents = calendar.dateComponents([.hour], from: date)
                
                if let hour = dateComponents.hour {
                    
                    switch hour {
                    case 12...18:
                        weatherImage = WeatherBackgrounds.night
                    case 19...23:
                        weatherImage = WeatherBackgrounds.night
                    default:
                        weatherImage = WeatherBackgrounds.clear
                    }
                    
                }
            }
        }
        
        var image : UIImage? = nil
        
        repeat {
            let randomInt = randomNumber(range: Range(1...3))
            let imageName = weatherImage.rawValue + "-\(randomInt)"
            
            image = UIImage(named: imageName)
        } while image == nil
        
        return image
    }
    
    func randomNumber(range: Range<UInt32>) -> Int {
        return Int(arc4random_uniform(UInt32(range.upperBound - range.lowerBound)) + range.lowerBound)
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
}

//MARK: - CLLocationManagerDelegate
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
        //get user location
        let loc = locations[0]
        let latitude = Double(round(100 * loc.coordinate.latitude) / 100)
        let longitude = Double(round(100 * loc.coordinate.longitude) / 100)
        
        //make request to weather service
        WeatherAPI.shared.getWeatherResultsFor(latitude: latitude, longitude: longitude)
        WeatherAPI.shared.getForecastResultsFor(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[JOSH] error: \(error)")
    }
}

