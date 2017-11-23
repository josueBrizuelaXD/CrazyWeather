//
//  ForecastCollectionViewController.swift
//  CrazyWeather
//
//  Created by Josh on 10/16/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import UIKit
var dayTimeFrames = [DayFrameForecast]()

class ForecastViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //add observer
        NotificationCenter.default.addObserver(self, selector: #selector(onNotification(notification:)), name: WeatherViewController.forecastNotification, object: nil)
    }
    
    @objc func onNotification(notification: Notification) {
        
        if let userInfo = notification.userInfo as? [String: Any] {
            print("[JOSH] userInfo: \(userInfo)")
            if let list = userInfo["list"] as? [Any] {
                print("[JOSH] list count: \(list.count)")
              if let main = list[0] as? [String: Any] {
                    print("[JOSH] \(main)")
                if let pres = main["main"] as? [String:Any] {
                    print("[JOSH] press\(pres)")
                }
                }
            }
        }
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension ForecastViewController: UICollectionViewDelegate {
    
}

extension ForecastViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dayTimeFrames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "dayFrameViewCell", for: indexPath) as! DayFrameCollectionViewCell
        
        let dayFrame = dayTimeFrames[indexPath.row]
        cell.timeFrameTempLabel.text = dayFrame.temperature
        
        return cell
    }
}
