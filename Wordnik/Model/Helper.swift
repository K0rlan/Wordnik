//
//  Helper.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import Foundation

extension String {
    func validatePassword() -> Bool{
        self.count < 8 ? true : false
    }
}

