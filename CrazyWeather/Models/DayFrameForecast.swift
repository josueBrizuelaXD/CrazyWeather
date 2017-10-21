//
//  DayFrameForecast.swift
//  CrazyWeather
//
//  Created by Josh on 10/20/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import Foundation

class DayFrameForecast {
    let timeFrame: String
    let temperature : String
    
    init(timeFrame: String, temperature: String) {
        self.temperature = temperature
        self.timeFrame = timeFrame
    }
}
