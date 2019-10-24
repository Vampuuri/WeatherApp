//
//  WeatherObject.swift
//  Weather App
//
//  Created by Essi Supponen on 11/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation

enum WeatherType: Int {
    case Clear
    case Cloudy
    case PartlyCloudy
    case Rain
    case Thunder
    case Snow
    case Misty
}

class WeatherObject: NSObject, NSCoding {
    var city: String
    var temperature: Double
    var weatherType: WeatherType
    var dateAndTime: NSDate?
    
    init(city: String, temperature: Double, weatherType: String) {
        self.city = city
        self.temperature = temperature
        self.weatherType = WeatherObject.getWeatherTypeByString(weatherType)
    }
    
    required init(coder decoder: NSCoder) {
        self.city = decoder.decodeObject(forKey: "city") as! String
        self.temperature = decoder.decodeDouble(forKey: "temperature")
        self.weatherType = WeatherType(rawValue: (decoder.decodeInteger(forKey: "weatherType" )))!
        self.dateAndTime = decoder.decodeObject(forKey: "dateAndTime") as? NSDate
    }
    
    func encode(with encoder: NSCoder) {
        encoder.encode(self.city, forKey: "city")
        encoder.encode(self.temperature, forKey: "temperature")
        encoder.encode(self.weatherType.rawValue, forKey: "weatherType")
        encoder.encode(self.dateAndTime, forKey: "dateAndTime")
    }
    
    class func getWeatherTypeByString(_ str: String) -> WeatherType {
        if str == "Clear" {
            return WeatherType.Clear
        } else if str == "Clouds" {
            return WeatherType.Cloudy
        } else if str == "Rain" || str == "Drizzle" {
            return WeatherType.Rain
        } else if str == "Thunderstorm" {
            return WeatherType.Thunder
        } else if str == "Snow" {
            return WeatherType.Snow
        } else {
            return WeatherType.Misty
        }
    }
}
