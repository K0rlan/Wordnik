//
//  DataSingleton.swift
//  Wordnik
//
//  Created by Korlan Omarova on 14.02.2021.
//

import Foundation

class DataSingleton {
    static let sharedInstance = DataSingleton()
    var synonims = [String]()
    var antonyms = [String]()
}
