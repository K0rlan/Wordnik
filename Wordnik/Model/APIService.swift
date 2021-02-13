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
    case getDefinitions(text: String)
    case getPronunciations(text: String)
    case getAntonym(text: String)
}

extension APIService: TargetType{
    var baseURL: URL {
        return URL(string: "http://api.wordnik.com:80/v4/word.json/")!
    }
    
    var path: String {
        switch self {
        case .getSynonims(let text):
            return "\(text)/relatedWords"
        case .getDefinitions(let text):
            return "\(text)/definitions"
        case .getPronunciations(let text):
            return "\(text)/pronunciations"
        case .getAntonym(let text):
            return "\(text)/relatedWords"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getSynonims:
            return .get
        case .getDefinitions:
            return .get
        case .getPronunciations:
            return .get
        case .getAntonym:
            return .get
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .getSynonims:
            let paramsForSynonims: [String : String] = [
                "useCanonical" : "false",
                "relationshipTypes" : "synonym",
                "limitPerRelationshipType" : "5" ,
                "api_key" : "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
            ]
            return .requestParameters(parameters: paramsForSynonims, encoding: URLEncoding.default )
        case .getDefinitions:
            let paramsForDefinitions: [String : String] = [
                "limit" : "1" ,
                "includeRelated" : "false",
                "useCanonical" : "false",
                "includeTags" : "false",
                "api_key" : "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
            ]
            return .requestParameters(parameters: paramsForDefinitions, encoding: URLEncoding.default)
        case .getPronunciations:
            let paramsForPronunciations: [String : String] = [
                "useCanonical" : "false",
                "limit" : "1" ,
                "api_key" : "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
            ]
            return .requestParameters(parameters: paramsForPronunciations, encoding: URLEncoding.default)
        case .getAntonym:
            let paramsForAntonyms: [String : String] = [
                "useCanonical" : "false",
                "relationshipTypes" : "antonym",
                "limitPerRelationshipType" : "5" ,
                "api_key" : "a2a73e7b926c924fad7001ca3111acd55af2ffabf50eb4ae5"
            ]
            return .requestParameters(parameters: paramsForAntonyms, encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type" : "application/json"]
    }
    
    
}
