//
//  FilePathFinder.swift
//  Weather App
//
//  Created by Essi Supponen on 24/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation

class FilePathFinder {
    // Static function to get the path to cache directory
    // Used by WeatherFetcher, CurrentWeatherViewController and WeatherForecastViewController
    static func getPathToDirectoryFile(_ filename: String) -> String {
        let cacheDirectories =
            NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                FileManager.SearchPathDomainMask.userDomainMask, true)
        let cacheDirectory = cacheDirectories[0]
        let pathWithFileName = "\(cacheDirectory)/\(filename).txt"
        
        return pathWithFileName
    }
}
