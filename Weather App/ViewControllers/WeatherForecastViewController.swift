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
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "someID")
        cell.textLabel?.text = "Hello \((data![indexPath[1]] as! WeatherObject).weatherType)"
        return cell
    }
}
