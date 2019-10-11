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
    
    var weather: WeatherObject?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Current Weather")
        
        self.updateWeather(WeatherObject(city: "Tampere", temperature: 10.0, weatherType: "Rain"))
    }
    
    func updateWeather(_ weather: WeatherObject) {
        self.weather = weather
        self.cityLabel.text = weather.city
        self.temperatureLabel.text = "\(weather.temperature) \u{00B0}C"
        
        var image: UIImage?
        
        if weather.weatherType == WeatherType.clear {
            image = UIImage(named: "clear")
        } else if weather.weatherType == WeatherType.cloudy {
            image = UIImage(named: "cloudy")
        } else if weather.weatherType == WeatherType.partlyCloudy {
            image = UIImage(named: "partlyCloudy")
        } else if weather.weatherType == WeatherType.rainy {
            image = UIImage(named: "rainy")
        } else if weather.weatherType == WeatherType.snow {
            image = UIImage(named: "snow")
        } else if weather.weatherType == WeatherType.thunder {
            image = UIImage(named: "thunder")
        } else {
            image = UIImage(named: "misty")
        }
        
        self.iconImageView.image = image
    }
}
