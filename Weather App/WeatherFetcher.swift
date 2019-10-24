//
//  WeatherFetcher.swift
//  Weather App
//
//  Created by Essi Supponen on 24/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation

class WeatherFetcher {
    private static let APIKEY = "60881c23fa92d269a2479d5378c082d7"
    
    private class func fetchUrl(url : String, completionBlock: @escaping (Optional<[String : Any]>) -> Void) {
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
    
    private class func fetchCurrentWeather(_ locationPart: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?\(locationPart)&APPID=\(APIKEY)"
        
        fetchUrl(url: url) {
            (output) in
            
            if let json = output {
                let city = json["name"] as! String
                let objectTemperature = json["main"] as? [String : Any]
                let objectWeather = json["weather"] as? [[String : Any]]
                let temperature = objectTemperature!["temp"] as! Double
                let weatherTypeString = objectWeather![0]["main"] as! String
                
                let weatherObject = WeatherObject(city: city, temperature: temperature - 273.15, weatherType: weatherTypeString)
                weatherObject.dateAndTime = NSDate()
                print(weatherObject)
                
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: weatherObject, requiringSecureCoding: false)
                    try data.write(to: URL(fileURLWithPath: FilePathFinder.getPathToDirectoryFile("current")))
                } catch {
                    NSLog("Error: could not write a file")
                }
                
            } else {
                print("Something went wrong...")
            }
        }
    }
    
    class func fetchCurrentWeather(city: String) {
        fetchCurrentWeather("q=\(city)")
    }
    
    class func fetchCurrentWeather(latitude: Double, longitude: Double) {
        fetchCurrentWeather("lat=\(latitude)&lon=\(longitude)")
    }
    
    class func fetchWeatherForecast(city: String) {
        // Will be implemented later
    }
    
    class func fetchWeatherForecast(latitude: Double, longitude: Double) {
        // Will be implemented later
    }
}
