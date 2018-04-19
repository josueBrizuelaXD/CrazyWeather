//
//  MapViewController.swift
//  CrazyWeather
//
//  Created by Josh on 4/12/18.
//  Copyright © 2018 josuebrizuela. All rights reserved.
//

import UIKit
import Aeris
import AerisMap

class RadarMapViewController: UIViewController {
     private var locationToken : NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.enableBasicLocationServices()
        
        //Observe changes in the location property
        locationToken = LocationManager.shared.observe(\.location) {
            locationManager , _ in
           
           
            DispatchQueue.main.async {
                 //make request for location
                let place = AWFPlace(coordinate: locationManager.location)
                place?.elevationM = 100
                let options = AWFRequestOptions()
                options.place = place!
                let mapConfig = AWFWeatherMapConfig()
                mapConfig.setRequestOptions(options, for: .dewPointsTextDark)
                let weatherMap = AWFWeatherMap(mapType: .apple, config: mapConfig)
                
                //update map
                weatherMap?.weatherMapView.frame = self.view.bounds
                self.view.addSubview(weatherMap!.weatherMapView)
                weatherMap?.add(.temperatures)
                weatherMap?.setMapCenter(locationManager.location, zoomLevel: 8, animated: true)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //make a new location request to update view in case user has new location
        LocationManager.shared.requestNewLocation()
    }
}
