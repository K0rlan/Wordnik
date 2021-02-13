//
//  Helper.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import Foundation
import UIKit
extension String {
    func validatePassword() -> Bool{
        self.count < 8 ? true : false
    }
}

struct Constants {
    static let cyanColor = UIColor(red: 106/255, green: 204/255, blue: 206/255, alpha: 1)
    static let specialPurple = UIColor(red: 61/255, green: 78/255, blue: 150/255, alpha: 1)
    static let specialYellow = UIColor(red: 249/255, green: 220/255, blue: 118/255, alpha: 1)
    static let voice = UIImage(named: "megaphone")
    
 }
