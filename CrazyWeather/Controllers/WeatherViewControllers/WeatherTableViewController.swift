//
//  WeatherTableViewController.swift
//  CrazyWeather
//
//  Created by Josh on 11/8/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import UIKit

class WeatherTableViewController: UITableViewController {
    @IBOutlet weak var sunriseLbl: UILabel!
    @IBOutlet weak var sunsetLbl: UILabel!
    @IBOutlet weak var pressureLbl: UILabel!
    @IBOutlet weak var humidityLbl: UILabel!
    @IBOutlet weak var windSpeedLbl: UILabel!
    @IBOutlet weak var windDegLbl: UILabel!
    @IBOutlet weak var maxTempLbl: UILabel!
    @IBOutlet weak var minTempLbl: UILabel!
    
    private var token: NSKeyValueObservation?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        token = WeatherAPI.shared.observe(\.weather) {
            weatherAPI, _ in
            DispatchQueue.main.async {
                self.updateWeatherLabelsWith(weatherData: weatherAPI.weather)
            }
            
        }
    }
    
    func updateWeatherLabelsWith(weatherData: Weather?) {
        guard let weatherData = weatherData else { return }
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("hh:mm a")
        let sunriseDate = Date(timeIntervalSince1970: TimeInterval(weatherData.sys.sunrise))
        let sunsetDate = Date(timeIntervalSince1970: TimeInterval(weatherData.sys.sunset))
        sunriseLbl.text = dateFormatter.string(from: sunriseDate)
        sunsetLbl.text = dateFormatter.string(from: sunsetDate)
        
        if let pressure = weatherData.main.pressure {
             pressureLbl.text = String(pressure)
        }
        
        if let humidity = weatherData.main.humidity {
            humidityLbl.text = String(humidity) + "%"
        }
        
        if let windSpeed = weatherData.wind?.speed {
            windSpeedLbl.text = String(windSpeed) + " mph"
        }
        
        if let winDeg = weatherData.wind?.deg {
            windSpeedLbl.text = String(winDeg)
        }
        
        if let maxTemp = weatherData.main.tempMax {
            maxTempLbl.text = String(Int(maxTemp.rounded()))
        }
        
        if let minTemp = weatherData.main.tempMin {
            minTempLbl.text = String(Int(minTemp.rounded()))
        }
        
        
       
    }

}
