//
//  Weather.swift
//  CrazyWeather
//
//  Created by Josh on 11/23/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import Foundation

class Weather: NSObject, Codable {
    
    let weather: [WeatherSummary]
    let main : MainWeatherData
    let wind: WindData?
    let name: String
    let sys: SysData
    let dt: Int
    
    init(weather:[WeatherSummary], main: MainWeatherData, wind: WindData, name: String, sys: SysData, dt: Int) {
        self.weather = weather
        self.main = main
        self.wind = wind
        self.name = name
        self.sys = sys
        self.dt = dt
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        weather = try container.decode([WeatherSummary].self, forKey: .weather)
        main = try container.decode(MainWeatherData.self, forKey: .main)
        wind = try container.decodeIfPresent(WindData.self, forKey: .wind)
        name = try container.decode(String.self, forKey: .name)
        sys = try container.decode(SysData.self, forKey: .sys)
        dt = try container.decode(Int.self, forKey: .dt)
    }
}


struct WeatherSummary: Codable {
    
    let main: String
    let summary: String
    
    enum CodingKeys: String, CodingKey {
        case main
        case summary = "description"
        
    }
}

class MainWeatherData: Codable {
    let temp: Double
    let pressure: Double?
    let humidity: Int?
    let tempMin: Double?
    let tempMax: Double?
    
    enum CodingKeys: String, CodingKey {
        case temp
        case pressure
        case humidity
        case tempMin = "temp_min"
        case tempMax = "temp_max"
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Double.self, forKey: .temp)
        pressure = try container.decodeIfPresent(Double.self, forKey: .pressure)
        humidity = try container.decodeIfPresent(Int.self, forKey: .humidity)
        tempMin = try container.decodeIfPresent(Double.self, forKey: .tempMin)
        tempMax = try container.decodeIfPresent(Double.self, forKey: .tempMax)
    }
}

class WindData: Codable {
    let speed: Double?
    let deg: Double?
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decodeIfPresent(Double.self, forKey: .speed)
        deg = try container.decodeIfPresent(Double.self, forKey: .deg)
        
    }
}

struct SysData: Codable {
    let sunrise: Int
    let sunset: Int
}
