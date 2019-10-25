//
//  CityViewController.swift
//  Weather App
//
//  Created by Essi Supponen on 09/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation
import UIKit

class CityViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet weak var tableView: UITableView!
    var cities = ["Use GPS", "Helsinki", "Tampere", "Turku", "Oulu"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("City")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.selectRow(at: [0,0], animated: false, scrollPosition: UITableView.ScrollPosition.middle)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let defaultDB = UserDefaults.standard
        let chosenCity = defaultDB.string(forKey: "city")
        var position = [0,0] as IndexPath
        
        if let city = chosenCity, city != "" {
            if let cityPosition = cities.firstIndex(of: city) {
                position = [0, cityPosition]
            }
        }
        
        tableView.selectRow(at: position, animated: false, scrollPosition: UITableView.ScrollPosition.middle)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        print(cities[didSelectRowAt[1]])
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "someID")
        
        cell.textLabel?.text = cities[indexPath[1]]
        
        return cell
    }
}
