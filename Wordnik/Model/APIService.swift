//
//  APIService.swift
//  WordnikMVCApp
//
//  Created by Korlan Omarova on 12.02.2021.
//

import Foundation
import Moya

enum APIService {
    case getSynonims(text: String)
}

extension APIService: TargetType{
    var baseURL: URL {
        return URL(string: "http://api.wordnik.com:80/v4/word.json/")!
    }
    
    var path: String {
        switch self {
        case .getSynonims(let text):
            return "\(text)/relatedWords"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSynonims:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getSynonims:
            let params: [String : String] = [
                "useCanonical" : "false",
                "relationshipTypes" : "synonym",
                "limitPerRelationshipType" : "5" ,
                "api_key" : "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
            ]
            return .requestParameters(parameters: params, encoding: URLEncoding.default )
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    
}
