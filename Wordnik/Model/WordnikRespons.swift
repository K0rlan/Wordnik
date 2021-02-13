//
//  WordnikResponse.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import Foundation

struct SynonymResponse: Decodable {
    var relationshipType: String
    var words: [String]
}

struct DefinitionResponse: Decodable{
    var attributionText: String
    var text: String
}

struct PronunciationResponse: Decodable{
    var attributionText: String
    var raw: String
}

struct AntonymResponse: Decodable {
    var relationshipType: String
    var words: [String]
}
