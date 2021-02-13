//
//  WordnikResponse.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import Foundation

struct WordnikRespons: Decodable {
    var relationshipType: String
    var words: [String]
}
