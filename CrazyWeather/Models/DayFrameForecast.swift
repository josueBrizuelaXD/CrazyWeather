//
//  DayFrameForecast.swift
//  CrazyWeather
//
//  Created by Josh on 10/20/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import Foundation

struct DayFrameForecast: Codable {
    let temperature : String
    
   
    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        
    }
}
