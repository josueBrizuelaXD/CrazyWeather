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
    var dayTimeFrames = [Forecast]()
    
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
        cell.timeFrameTempLabel.text = dayFrame.temperature
        
        return cell
    }
}
