//
//  WeatherObject.swift
//  Weather App
//
//  Created by Essi Supponen on 11/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation

enum WeatherType {
    case clear
    case cloudy
    case partlyCloudy
    case rainy
    case thunder
    case snow
    case misty
}

class WeatherObject: NSObject, NSCoding {
    var city: String
    var temperature: Double
    var weatherType: WeatherType
    
    init(city: String, temperature: Double, weatherType: String) {
        self.city = city
        self.temperature = temperature
        self.weatherType = WeatherObject.getWeatherTypeByString(weatherType)
    }
    
    required init(coder decoder: NSCoder) {
        
    }
    
    func encode(with encoder: NSCoder) {
        
    }
    
    class func getWeatherTypeByString(_ str: String) -> WeatherType {
        if str == "Clear" {
            return WeatherType.clear
        } else if str == "Clouds" {
            return WeatherType.cloudy
        } else if str == "Rain" || str == "Drizzle" {
            return WeatherType.rainy
        } else if str == "Thunderstorm" {
            return WeatherType.thunder
        } else if str == "Snow" {
            return WeatherType.snow
        } else {
            return WeatherType.misty
        }
    }
}
