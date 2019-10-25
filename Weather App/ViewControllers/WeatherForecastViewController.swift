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
        
        tableView.delegate = self
        tableView.dataSource = self
        readForecastFromFile()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        readForecastFromFile()
    }
    
    func readForecastFromFile() {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: FilePathFinder.getPathToDirectoryFile("forecast")))
            let forecast = try NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(data) as! NSArray
            self.data = forecast
            tableView.reloadData()
        } catch {
            NSLog("Error: file not found. Trying again in 0.5 seconds")
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.readForecastFromFile()
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.data!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.subtitle, reuseIdentifier: "someID")
        let dataobject = data![indexPath[1]] as! WeatherObject
        
        cell.textLabel?.text = String(format: "\(dataobject.weatherType) %.1f \u{00B0}C", dataobject.temperature)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "dd/MM kk:mm"
        
        cell.detailTextLabel?.text = formatter.string(from: dataobject.dateAndTime! as Date)
        
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
