//
//  LocationManager.swift
//  CrazyWeather
//
//  Created by Josh on 4/18/18.
//  Copyright © 2018 josuebrizuela. All rights reserved.
//

import CoreLocation

class LocationManager: NSObject {
    static let shared = LocationManager()
    
    private lazy var locationManager : CLLocationManager = {
       let locationManager = CLLocationManager()
        locationManager.delegate = self
        return locationManager
    }()
   @objc dynamic private(set) var location = CLLocationCoordinate2D(latitude: 0, longitude: 0)
    
    //MARK: - CoreLocation
    
  public func enableBasicLocationServices() {
    
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
    
   public func startReceivingSignificantLocationUpdates() {
        if !CLLocationManager.significantLocationChangeMonitoringAvailable() {
            print("significant locations services not enabled")
            return
        }
        
        locationManager.startMonitoringSignificantLocationChanges()
    }

    public func requestNewLocation() {
        //if we have a recent location use it to make a new request.
        
        if let currentLoc = locationManager.location {
            let latitude = currentLoc.coordinate.latitude
            let longitude = currentLoc.coordinate.longitude
            
            location = currentLoc.coordinate
            
            WeatherAPI.shared.getWeatherResultsFor(latitude: latitude, longitude: longitude)
            WeatherAPI.shared.getForecastResultsFor(latitude: latitude, longitude: longitude)
            //else request new user location
        } else {
            enableBasicLocationServices()
        }
    }
    
}


//MARK: - CLLocationManagerDelegate

extension LocationManager : CLLocationManagerDelegate {
    
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
        
        self.location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        //make request to weather service
        WeatherAPI.shared.getWeatherResultsFor(latitude: latitude, longitude: longitude)
        WeatherAPI.shared.getForecastResultsFor(latitude: latitude, longitude: longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("[JOSH] error: \(error)")
    }
}
