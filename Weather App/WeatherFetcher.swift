//
//  WeatherFetcher.swift
//  Weather App
//
//  Created by Essi Supponen on 24/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation

class WeatherFetcher {
    private let APIKEY = "60881c23fa92d269a2479d5378c082d7"
    
    func fetchUrl(url : String, completionBlock: @escaping (Optional<[String : Any]>) -> Void) {
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let url : URL? = URL(string: url)
        
        let task = session.dataTask(with: url!) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String : Any]
                completionBlock(json)
            } catch let error {
                print(error.localizedDescription)
                completionBlock(nil)
            }
        }
        
        task.resume();
    }
    
    static func fetchCurrentWeather(city: String) {
        
    }
    
    static func fetchCurrentWeather(longitude: Double, latitude: Double) {
        // Will be implemented later
    }
    
    static func fetchWeatherForecast(city: String) {
        
    }
    
    static func fetchWeatherForecast(longitude: Double, latitude: Double) {
        // Will be implemented later
    }
}
