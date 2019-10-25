//
//  FilePathFinder.swift
//  Weather App
//
//  Created by Essi Supponen on 24/10/2019.
//  Copyright © 2019 Essi Supponen. All rights reserved.
//

import Foundation

class FilePathFinder {
    static func getPathToDirectoryFile(_ filename: String) -> String {
        // For now this code will return document directory
        
        let cacheDirectories =
            NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.cachesDirectory,
                                                FileManager.SearchPathDomainMask.userDomainMask, true)
        let cacheDirectory = cacheDirectories[0]
        let pathWithFileName = "\(cacheDirectory)/\(filename).txt"
        
        return pathWithFileName
    }
}
