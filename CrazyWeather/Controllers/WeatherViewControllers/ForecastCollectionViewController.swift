//
//  ForecastCollectionViewController.swift
//  CrazyWeather
//
//  Created by Josh on 10/16/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import UIKit


class ForecastViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    private var token: NSKeyValueObservation?
    private var dayFrames = [DayFrame]()
    
    private struct DayFrame {
        let forecastFrame : ForecastFrame
        let image: UIImage?
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        collectionView.dataSource = self
        
        token = WeatherAPI.shared.observe(\.forecast) {
            weatherAPI, v in
//            print("[JOSH]: forecast property \(weatherAPI) and v: \(v)")
            if let list = weatherAPI.forecast?.list {
                var dayForecastFrames = [ForecastFrame]()
                
                if list.count >= 7 {
                    dayForecastFrames = Array(list[...7])
                } else {
                    dayForecastFrames = list
                }
                
                for frame in dayForecastFrames {
                    
                    
                    WeatherAPI.shared.getIcon(name: frame.weather[0].icon, completion: {
                        data in
                        if let data = data {
                          let image = UIImage(data: data)
                            let dayFrame = DayFrame(forecastFrame: frame, image: image)
                            self.dayFrames.append(dayFrame)
                            
                           
                        } else {
                            let dayFrame = DayFrame(forecastFrame: frame, image: nil)
                            self.dayFrames.append(dayFrame)
                        }
                        
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }

                    })
                }
                
                
                
                
            }
            
        }
        
        
        
    }
}

extension ForecastViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayFrames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayFrameViewCell", for: indexPath) as! DayFrameCollectionViewCell
        
        let dayFrame = dayFrames[indexPath.row]
       
      
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("h a")
        
        let date = Date(timeIntervalSince1970: TimeInterval(dayFrame.forecastFrame.dt))
        
        cell.timeFrameLabel.text = dateFormatter.string(from: date)
        cell.timeFrameTempLabel.text = String(Int(dayFrame.forecastFrame.main.temp.rounded())) + "º"
        if let image = dayFrame.image {
            cell.timeFrameImage.image = image
        }
        return cell
    }
}
