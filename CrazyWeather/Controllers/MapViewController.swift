//
//  MapViewController.swift
//  CrazyWeather
//
//  Created by Josh on 10/10/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import UIKit
import CoreLocation


class MapViewController: UIViewController {
    
    var locationManager : CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
       
    }
}

extension MapViewController : CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        print("location: \(location)")
    }
}
