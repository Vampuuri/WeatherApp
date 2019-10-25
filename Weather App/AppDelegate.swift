//
//  AppDelegate.swift
//  Weather App
//
//  Created by Essi Supponen on 09/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import UIKit
import CoreLocation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate,CLLocationManagerDelegate {

    var window: UIWindow?
    // for location purposes
    var locationManager: CLLocationManager?
    
    // all ViewControllers
    var currentWeatherViewController: CurrentWeatherViewController?
    var weatherForecastViewController: WeatherForecastViewController?
    var cityViewController: CityViewController?
    
    // timer to fetch new weather data after some time
    var updateTimer: Timer?
    
    // this code came here without asking and i'm too scared to delete it
    func doneFetching(data: Data?, response: URLResponse?, error: Error?) {

    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // gets all ViewController objects
        let tabBarController = self.window!.rootViewController as! UITabBarController
        self.currentWeatherViewController = tabBarController.viewControllers![0] as? CurrentWeatherViewController
        self.weatherForecastViewController = tabBarController.viewControllers![1] as? WeatherForecastViewController
        self.cityViewController = tabBarController.viewControllers![2] as? CityViewController
        
        // gives cityViewController the method to fetch new data immediately
        self.cityViewController!.askFetchForNewData = self.fetchInitialWeatherData
        
        // request location authorisation
        self.locationManager = CLLocationManager();
        self.locationManager?.requestAlwaysAuthorization();
        self.locationManager?.delegate = self;
        
        // first of all fetch initial weatherdata
        fetchInitialWeatherData()
        
        // timer fetches data again every 5 minutes
        updateTimer = Timer.scheduledTimer(timeInterval: 300.0, target: self, selector: #selector(fetchInitialWeatherData), userInfo: nil, repeats: true)
        
        return true
    }
    
    // asks WeatherFetcher to fetch weather data
    @objc
    func fetchInitialWeatherData() {
        // check if there is city saved into user defaults
        let defaultDB = UserDefaults.standard
        let chosenCity = defaultDB.string(forKey: "city")
        
        if let city = chosenCity, city != "" {
            // if there is city, use it to find data
            WeatherFetcher.fetchCurrentWeather(city: city)
            WeatherFetcher.fetchWeatherForecast(city: city)
        } else {
            // if there isn't, use location
            self.locationManager?.requestLocation();
        }
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
        updateTimer?.invalidate()
    }
    
    // locates device and uses coordinates to fetch weather data
    func locationManager(_ : CLLocationManager,didUpdateLocations: [CLLocation]) {
        if let location = didUpdateLocations.last {
            WeatherFetcher.fetchCurrentWeather(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            WeatherFetcher.fetchWeatherForecast(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        }
    }
    
    // sometimes you just fail
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
}

