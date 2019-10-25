//
//  WeatherFetcher.swift
//  Weather App
//
//  Created by Essi Supponen on 24/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation

class WeatherFetcher {
    // APIKEY for OpenWeatherAPI
    // Such private
    // Very secret
    private static let APIKEY = "60881c23fa92d269a2479d5378c082d7"
    
    // Fetches data from given url and sends it to completionblock as "json" (String : Any dictionary)
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
    
    // fetches current weather data
    private class func fetchCurrentWeather(_ locationPart: String) {
        let url = "https://api.openweathermap.org/data/2.5/weather?\(locationPart)&APPID=\(APIKEY)"
        
        fetchUrl(url: url) {
            (output) in
            
            if let json = output {
                let message = json["message"] as? String
                
                if message != nil {
                    // If "message" is found, it means there was an error
                    print("error")
                } else {
                    // brutally rip needed data out of json
                    let city = json["name"] as! String
                    let objectTemperature = json["main"] as? [String : Any]
                    let objectWeather = json["weather"] as? [[String : Any]]
                    let temperature = objectTemperature!["temp"] as! Double
                    let weatherTypeString = objectWeather![0]["main"] as! String
                    
                    // Create weatherObject
                    let weatherObject = WeatherObject(city: city, temperature: temperature - 273.15, weatherType: weatherTypeString)
                    weatherObject.dateAndTime = NSDate()
                    
                    // save weatherObject into a file
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: weatherObject, requiringSecureCoding: false)
                        try data.write(to: URL(fileURLWithPath: FilePathFinder.getPathToDirectoryFile("current")))
                    } catch {
                        NSLog("Error: could not write a file")
                    }
                }
                
            } else {
                print("Something went wrong...")
            }
        }
    }
    
    // fetches current weather data by city
    class func fetchCurrentWeather(city: String) {
        fetchCurrentWeather("q=\(city)")
    }
    
    // fetches current weather data by coordinates
    class func fetchCurrentWeather(latitude: Double, longitude: Double) {
        fetchCurrentWeather("lat=\(latitude)&lon=\(longitude)")
    }
    
    // fetches weather forecast data
    private class func fetchWeatherForecast(_ locationPart: String) {
        let url = "https://api.openweathermap.org/data/2.5/forecast?\(locationPart)&APPID=\(APIKEY)"
        
        fetchUrl(url: url) {
            (output) in
            
            if let json = output {
                let message = json["message"] as? String
                
                if message != nil {
                    // If "message" is found, it means there was an error
                    print("error")
                } else {
                    // formatter is used to get date from json to NSDate
                    let formatter = DateFormatter()
                    formatter.locale = Locale(identifier: "en_US_POSIX")
                    formatter.dateFormat = "yyyy-MM-dd kk:mm:ss"
                    
                    let list = json["list"] as! [[String : Any]]
                    
                    // create empty array of weatherObjects
                    var forecastArray: Array<WeatherObject> = []
                    
                    for item in list {
                        // brutally rip needed data out of json
                        let objectTemperature = item["main"] as? [String : Any]
                        let objectWeather = item["weather"] as? [[String : Any]]
                        let temperature = objectTemperature!["temp"] as! Double
                        let weatherTypeString = objectWeather![0]["main"] as! String
                        let dateTimeString = item["dt_txt"] as! String
                        
                        // create weatherObject and add it to the array
                        let weatherObject = WeatherObject(city: "", temperature: temperature - 273.15, weatherType: weatherTypeString)
                        weatherObject.dateAndTime = formatter.date(from: dateTimeString) as NSDate?
                        forecastArray.append(weatherObject)
                    }
                    
                    // convert array to NSArray
                    let forecastNSArray = forecastArray as NSArray
                    
                    // save weatherObject into a file
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: forecastNSArray, requiringSecureCoding: false)
                        try data.write(to: URL(fileURLWithPath: FilePathFinder.getPathToDirectoryFile("forecast")))
                    } catch {
                        NSLog("Error: could not write a file")
                    }
                }
                
            } else {
                print("Something went wrong...")
            }
        }
    }
    
    // fetches weather forecast data by city
    class func fetchWeatherForecast(city: String) {
        fetchWeatherForecast("q=\(city)")
    }
    
    // fetches weather forecast data by coordinates
    class func fetchWeatherForecast(latitude: Double, longitude: Double) {
        fetchWeatherForecast("lat=\(latitude)&lon=\(longitude)")
    }
}
