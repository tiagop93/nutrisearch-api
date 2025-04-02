//
//  SearchResponse.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import Foundation

// MARK: - Professionals Search Response

struct SearchResponse: Codable {
    let count: Int
    let limit: Int
    let offset: Int
    let professionals: [Professional]
}
