//
//  AppDelegate.swift
//  CrazyWeather
//
//  Created by Josh on 10/5/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import UIKit
import Aeris
import GoogleMaps

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
        //start aeries engine
        AerisEngine.engine(withKey: SecretKeys.aerisAccessIDKey, secret: SecretKeys.aerisSecretKey)
        AerisEngine.enableDebug()
        
        //start google maps
        GMSServices.provideAPIKey(SecretKeys.googleMaps)
        return true
    }
}

