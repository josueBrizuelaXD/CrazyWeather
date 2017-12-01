//
//  DayFrameForecast.swift
//  CrazyWeather
//
//  Created by Josh on 10/20/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import Foundation

class Forecast: NSObject, Codable {
    let list : [ForecastFrame]
    
    init(list:[ForecastFrame]) {
        self.list = list
    }
}


struct ForecastFrame: Codable {
    let dt: Int
    let main: MainForecast
    let weather: [ForecastWeather]
}

struct MainForecast: Codable {
    let temp : Double
    let tempMin: Double
    let tempMax: Double
    
    enum CodingKeys: String, CodingKey {
        case temp
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }

}

struct ForecastWeather: Codable {
    let icon: String
}
