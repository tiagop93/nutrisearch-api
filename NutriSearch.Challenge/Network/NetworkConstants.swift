//
//  NetworkConstants.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 03/04/2025.
//

import Foundation

enum NetworkConstants {
    static let scheme = "https"
    static let host = "nutrisearch.vercel.app"
    
    // Query specific constants
    static let limit = "limit"
    static let offset = "offset"
    static let sortBy = "sort_by"
}

// MARK: - Network Endpoint Definition
enum Endpoint {
    case professionals
    case professionalsSearch
    
    var path: String {
        switch self {
        case .professionals:
            return "professionals"
        case .professionalsSearch:
            return "professionals/search"
        }
    }
    
    func url() -> URL? {
        var urlComponents = URLComponents()
        urlComponents.scheme = NetworkConstants.scheme
        urlComponents.host = NetworkConstants.host
        urlComponents.path = "/" + self.path
        return urlComponents.url
    }
    
}
