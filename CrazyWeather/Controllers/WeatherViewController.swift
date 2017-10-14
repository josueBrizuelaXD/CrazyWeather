//
//  WeatherViewController.swift
//  CrazyWeather
//
//  Created by Josh on 10/11/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
let apiKey = "082e6533e8dc5235d377971b22a93ce5"
    let apiURL = "http://api.openweathermap.org/data/2.5/weather?zip=77547&appid=082e6533e8dc5235d377971b22a93ce5"
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    override func viewDidLoad() {
        super.viewDidLoad()
getWeatherResultsFor(zipcode: "77547")
    }


    func getWeatherResultsFor(zipcode: String) {
        dataTask?.cancel()
        
        if var urlComponents = URLComponents(string:"https://api.openweathermap.org/data/2.5/weather") {
            urlComponents.query = "zip=\(zipcode)&appid=\(apiKey)"
            guard let url = urlComponents.url else { return }
            
            dataTask = defaultSession.dataTask(with: url) {
                data, response, error in
                defer {
                    print("defer")
                    self.dataTask = nil
                    
                }
                
                if let error = error {
                    print("error: \(error)")
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    self.parseJSON(data: data)
                }
            }
            dataTask?.resume()
        }
    }
    
    func parseJSON(data: Data) {
        
        var jsonDict : [String: Any]?
        
        do {
            jsonDict = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch let parseErr as NSError {
            print("err: \(parseErr)")
        }
        
        if let jsonDict = jsonDict {
            print("json: \(jsonDict)")
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
