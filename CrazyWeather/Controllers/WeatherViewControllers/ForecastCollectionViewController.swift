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
    private var dayForecastFrames = [ForecastFrame]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        token = WeatherAPI.shared.observe(\.forecast) {
            weatherAPI, v in
            print("[JOSH]: forecast property \(weatherAPI) and v: \(v)")
            if let list = weatherAPI.forecast?.list {
                
                if list.count >= 7 {
                    self.dayForecastFrames = Array(list[...7])
                } else {
                    self.dayForecastFrames = list
                }
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
                
            }
            
        }
        
        
        
    }
}

extension ForecastViewController: UICollectionViewDelegate {
    
}

extension ForecastViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayForecastFrames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayFrameViewCell", for: indexPath) as! DayFrameCollectionViewCell
        
        let dayFrame = dayForecastFrames[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate("h a")
        
        let date = Date(timeIntervalSinceReferenceDate: TimeInterval(dayFrame.dt))
        
        cell.timeFrameLabel.text = dateFormatter.string(from: date)
        cell.timeFrameTempLabel.text = String(Int(dayFrame.main.temp.rounded())) + "º"
        
        return cell
    }
}
