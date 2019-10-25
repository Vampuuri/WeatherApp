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
    @IBOutlet weak var newCityTextField: UITextField!
    @IBOutlet weak var newCityButton: UIButton!
    @IBOutlet weak var startEditingButton: UIButton!
    
    // Default cities
    var cities = ["Use GPS", "Helsinki", "Tampere", "Turku", "Oulu"]
    // function to fetch weather data, set by AppDelegate
    var askFetchForNewData: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("City")
        
        // set tableviews delegate and datasource to self
        tableView.delegate = self
        tableView.dataSource = self
        
        // check if user defaults have any cities
        let defaultDB = UserDefaults.standard
        let savedCitiesArray = defaultDB.array(forKey: "savedcities")
        
        if let savedCities = savedCitiesArray {
            // if yes, use them
            cities = savedCities as! [String]
        }
        
        // by default "use GPS" is selected
        tableView.selectRow(at: [0,0], animated: false, scrollPosition: UITableView.ScrollPosition.middle)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // check if there is selected city in user defaults
        let defaultDB = UserDefaults.standard
        let chosenCity = defaultDB.string(forKey: "city")
        var position = [0,0] as IndexPath
        
        if let city = chosenCity, city != "" {
            // if there is, select it
            if let cityPosition = cities.firstIndex(of: city) {
                position = [0, cityPosition]
            }
        }
        
        tableView.selectRow(at: position, animated: false, scrollPosition: UITableView.ScrollPosition.middle)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // save cities to user defaults
        let defaultDB = UserDefaults.standard
        defaultDB.set(cities, forKey: "savedcities")
        defaultDB.synchronize()
    }
    
    @IBAction func addCityButtonPressed(_ sender: Any) {
        // if there is any text in newCityTextFiel, just put it in as a city
        let text = newCityTextField!.text!
        
        if text != "" {
            cities.append(text)
            newCityTextField?.text = ""
            tableView.reloadData()
        }
    }
    
    // Toggles between normal mode and editing mode
    @IBAction func deleteCitiesButtonPressed(_ sender: Any) {
        if tableView.isEditing {
            tableView.isEditing = false
            newCityTextField.isEnabled = true
            newCityButton.isEnabled = true
            startEditingButton.setTitle("Edit cities", for: .normal)
        } else {
            tableView.isEditing = true
            newCityTextField.isEnabled = false
            newCityButton.isEnabled = false
            startEditingButton.setTitle("Stop editing", for: .normal)
        }
    }
    
    // when row is selected, set it as selected city to user defaults
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        var useCity = ""
        
        if didSelectRowAt[1] != 0 {
            useCity = cities[didSelectRowAt[1]]
        }
        
        let defaultDB = UserDefaults.standard
        defaultDB.set(useCity, forKey: "city")
        defaultDB.synchronize()
        
        // immediately ask to fetch data from new location
        askFetchForNewData!()
    }
    
    // remove row from tableview
    func tableView(_ tableView: UITableView, commit: UITableViewCell.EditingStyle, forRowAt: IndexPath) {
        if commit == .delete {
            cities.remove(at: forRowAt[1])
            tableView.reloadData()
        }
    }

    // move rows in tableview
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.cities[sourceIndexPath.row]
        cities.remove(at: sourceIndexPath.row)
        cities.insert(movedObject, at: destinationIndexPath.row)
    }
    
    // every cell of tableview can be edited, except for "use GPS"
    func tableView(_ tableView: UITableView, canEditRowAt: IndexPath) -> Bool {
        if canEditRowAt[1] == 0 {
            return false
        } else {
            return true
        }
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
