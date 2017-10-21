//
//  ForecastCollectionViewController.swift
//  CrazyWeather
//
//  Created by Josh on 10/16/17.
//  Copyright © 2017 josuebrizuela. All rights reserved.
//

import UIKit

let dayTimeFrames = [
    DayFrameForecast(timeFrame:"Now", temperature:"95º"),
    DayFrameForecast(timeFrame:"9PM", temperature:"94º"),
    DayFrameForecast(timeFrame:"10PM", temperature:"95º"),
    DayFrameForecast(timeFrame:"11PM", temperature:"96º"),
    DayFrameForecast(timeFrame:"12AM", temperature:"93º"),
    DayFrameForecast(timeFrame:"1AM", temperature:"95º"),
    DayFrameForecast(timeFrame:"2AM", temperature:"94º"),
    DayFrameForecast(timeFrame:"3AM", temperature:"95º"),
    DayFrameForecast(timeFrame:"4AM", temperature:"96º"),
    DayFrameForecast(timeFrame:"5AM", temperature:"93º")
]

class ForecastViewController: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        collectionView.dataSource = self
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
        cell.timeFrameLabel.text = dayFrame.timeFrame
        cell.timeFrameTempLabel.text = dayFrame.temperature
        
        return cell
    }
}
