//
//  CurrentWeatherViewController.swift
//  Weather App
//
//  Created by Essi Supponen on 09/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation
import UIKit

class CurrentWeatherViewController: UIViewController {
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var refreshTimer: Timer?
    
    var weather: WeatherObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Current Weather")
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.readWeatherFromFile()
        refreshTimer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(readWeatherFromFile), userInfo: nil, repeats: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        refreshTimer?.invalidate()
    }
    
    @objc
    func readWeatherFromFile() {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: FilePathFinder.getPathToDirectoryFile("current")))
            let wo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! WeatherObject
            self.weather = wo
            updateWeather()
        } catch {
            NSLog("Error: file not found. Trying again in 1.0 seconds")
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.readWeatherFromFile()
            }
        }
    }
    
    func updateWeather() {
        if !activityIndicator.isHidden {
            activityIndicator.stopAnimating()
            activityIndicator.hidesWhenStopped = true
        }
            
        self.cityLabel.text = self.weather!.city
        self.temperatureLabel.text = String(format: "%.1f \u{00B0}C", self.weather!.temperature)
        
        var image: UIImage?
        
        if self.weather!.weatherType == WeatherType.Clear {
            image = UIImage(named: "clear")
        } else if self.weather!.weatherType == WeatherType.Cloudy {
            image = UIImage(named: "cloudy")
        } else if self.weather!.weatherType == WeatherType.PartlyCloudy {
            image = UIImage(named: "partlyCloudy")
        } else if self.weather!.weatherType == WeatherType.Rain {
            image = UIImage(named: "rainy")
        } else if self.weather!.weatherType == WeatherType.Snow {
            image = UIImage(named: "snow")
        } else if self.weather!.weatherType == WeatherType.Thunder {
            image = UIImage(named: "thunder")
        } else {
            image = UIImage(named: "misty")
        }
        
        self.iconImageView.image = image
    }
}
