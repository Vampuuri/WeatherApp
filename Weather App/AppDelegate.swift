//
//  AppDelegate.swift
//  Weather App
//
//  Created by Essi Supponen on 09/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let APIKEY = "60881c23fa92d269a2479d5378c082d7"
    
    var currentWeatherViewController: CurrentWeatherViewController?
    var weatherForecastViewController: WeatherForecastViewController?
    var cityViewController: CityViewController?
    
    // fetch command for example:
    // http://api.openweathermap.org/data/2.5/forecast?id=524901&APPID={APIKEY}
    
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
        
        // Starts the task, spawns a new thread and calls the callback function
        task.resume();
    }
    
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {

    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let tabBarController = self.window!.rootViewController as! UITabBarController
        self.currentWeatherViewController = tabBarController.viewControllers![0] as? CurrentWeatherViewController
        self.weatherForecastViewController = tabBarController.viewControllers![1] as? WeatherForecastViewController
        self.cityViewController = tabBarController.viewControllers![2] as? CityViewController
        
        fetchUrl(url: "https://api.openweathermap.org/data/2.5/weather?q=Tampere&APPID=\(APIKEY)") {
            (output) in
            
            if let json = output {
                let city = json["name"] as! String
                let objectTemperature = json["main"] as? [String : Any]
                let objectWeather = json["weather"] as? [[String : Any]]
                let temperature = objectTemperature!["temp"] as! Double
                let weatherTypeString = objectWeather![0]["main"] as! String
                
                let weatherObject = WeatherObject(city: city, temperature: temperature - 273.15, weatherType: weatherTypeString)
                print(weatherObject)
                
                // self.currentWeatherViewController!.updateWeather(weatherObject)
                
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: weatherObject, requiringSecureCoding: false)
                    try data.write(to: URL(fileURLWithPath: self.getPathToFile("current")))
                } catch {
                    NSLog("error")
                }
                
                do {
                    let data = try Data(contentsOf: URL(fileURLWithPath: self.getPathToFile("current")))
                    let wo = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! WeatherObject
                    print(wo.city)
                    print(wo.temperature)
                    print(wo.weatherType)
                } catch {
                    NSLog("error")
                }
                
            } else {
                print("Something went wrong...")
            }
        }
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    func getPathToFile(_ filename: String) -> String {
        // For now this code will return document directory
        // Later it will be changed to cache
        
        let documentDirectories =
            NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = documentDirectories[0]
        let pathWithFileName = "\(documentDirectory)/\(filename).txt"
        
        return pathWithFileName
    }

}

