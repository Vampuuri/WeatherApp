//
//  WeatherForecastViewController.swift
//  Weather App
//
//  Created by Essi Supponen on 09/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation
import UIKit

class WeatherForecastViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    
    var data: NSArray? = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("Weather Forecast")
        
        var w1 = WeatherObject(city: "Tampere", temperature: 10, weatherType: "Rain")
        w1.dateAndTime = NSDate()
        var w2 = WeatherObject(city: "Tampere", temperature: 6, weatherType: "Clouds")
        w2.dateAndTime = NSDate()
        var w3 = WeatherObject(city: "Tampere", temperature: 7, weatherType: "Rain")
        w3.dateAndTime = NSDate()
        
        data = [w1, w2, w3]
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "someID")
        let dataobject = data![indexPath[1]] as! WeatherObject
        
        cell.textLabel?.text = String(format: "\(dataobject.weatherType) %.1f \u{00B0}C", dataobject.temperature)
        cell.detailTextLabel?.text = "\(dataobject.dateAndTime!)"
        
        if dataobject.weatherType == WeatherType.Clear {
            cell.imageView?.image = UIImage(named: "clear")
        } else if dataobject.weatherType == WeatherType.Cloudy {
            cell.imageView?.image = UIImage(named: "cloudy")
        } else if dataobject.weatherType == WeatherType.PartlyCloudy {
            cell.imageView?.image = UIImage(named: "partlyCloudy")
        } else if dataobject.weatherType == WeatherType.Rain {
            cell.imageView?.image = UIImage(named: "rainy")
        } else if dataobject.weatherType == WeatherType.Snow {
            cell.imageView?.image = UIImage(named: "snow")
        } else if dataobject.weatherType == WeatherType.Thunder {
            cell.imageView?.image = UIImage(named: "thunder")
        } else {
            cell.imageView?.image = UIImage(named: "misty")
        }
        
        return cell
    }
}
