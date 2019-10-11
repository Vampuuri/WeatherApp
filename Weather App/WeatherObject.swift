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

class WeatherObject {
    var city: String
    var temperature: Double
    var weatherType: WeatherType
    
    init(city: String, temperature: Double, weatherType: WeatherType) {
        self.city = city
        self.temperature = temperature
        self.weatherType = weatherType
    }
}
