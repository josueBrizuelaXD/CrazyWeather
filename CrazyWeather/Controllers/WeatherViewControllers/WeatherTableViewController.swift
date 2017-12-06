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
    @IBOutlet var daysLbls: [UILabel]!
    @IBOutlet var minTempLbls: [UILabel]!
    @IBOutlet var maxTempLbls: [UILabel]!
    @IBOutlet var weatherIcons: [UIImageView]!
    
    
    
    private var token: NSKeyValueObservation?
    private var forecastToken: NSKeyValueObservation?
    private var weekDays = [DayFrame]()
    
    private struct DayFrame {
        let forecast : ForecastFrame
        let image: UIImage?
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        token = WeatherAPI.shared.observe(\.weather) {
            weatherAPI, _ in
            DispatchQueue.main.async {
                self.updateWeatherViewssWith(weatherData: weatherAPI.weather)
            }
            
        }
        
        forecastToken = WeatherAPI.shared.observe(\.forecast) {
            weatherAPI, v in
//            print("[JOSH]: forecast property2 \(weatherAPI) and v2: \(v)")
            if let list = weatherAPI.forecast?.list {
               var dayForecastFrames = [ForecastFrame]()
                
                let days = Int((Double(list.count) / 8.0).rounded())
               
                print("[JOSH] list: \(list.count)")
                print("[JOSH] days: \(days)")
      
                for i in 1...days {
                   let dayIndex = i * 8
                    
                    if dayIndex <= list.count - 1 {
                        let day = list[dayIndex]
                        dayForecastFrames.append(day)
                    } else {
                        
                        dayForecastFrames.append(list[list.count - 1])
                    }
                }
                
                print("[JOSH] dayForecast array: \(dayForecastFrames.count)")
                
                for (i,frame) in dayForecastFrames.enumerated() {
                    WeatherAPI.shared.getIcon(name: frame.weather[0].icon, completion: {
                        data in
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.locale = Locale(identifier: "en_US")
                        dateFormatter.setLocalizedDateFormatFromTemplate("EEEE")
                        
                        DispatchQueue.main.async {
                            
                            let lbl = self.daysLbls[i]
                            let minTempLbl = self.minTempLbls[i]
                            let maxTempLbl = self.maxTempLbls[i]
                            let dayTime = frame.dt
                            let date = Date(timeIntervalSince1970: TimeInterval(dayTime))
                            lbl.text = dateFormatter.string(from: date)
                            minTempLbl.text = String(Int(frame.main.tempMin.rounded())) + "º"
                            maxTempLbl.text = String(Int(frame.main.tempMax.rounded())) + "º"
                            if let data = data {
                                if let image = UIImage(data:data) {
                                    let weatherIcon = self.weatherIcons[i]
                                    weatherIcon.image = image
                                }
                            }
                           
                        }
                    })
                }
                
            }
            
        }
    }
    
    func updateWeatherViewssWith(weatherData: Weather?) {
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
            windDegLbl.text = String(winDeg)
        }
        
        if let maxTemp = weatherData.main.tempMax {
            maxTempLbl.text = String(Int(maxTemp.rounded())) + "º"
        }
        
        if let minTemp = weatherData.main.tempMin {
            minTempLbl.text = String(Int(minTemp.rounded())) + "º"
        }
        
        
       
    }
    
  
}
