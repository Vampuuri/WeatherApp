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
        
        let documentDirectories =
            NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory,
                                                FileManager.SearchPathDomainMask.userDomainMask, true)
        let documentDirectory = documentDirectories[0]
        let pathWithFileName = "\(documentDirectory)/\(filename).txt"
        
        return pathWithFileName
    }
}
