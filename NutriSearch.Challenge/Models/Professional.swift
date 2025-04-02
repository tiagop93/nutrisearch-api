//
//  Professional.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import Foundation

// MARK: - Professional

struct Professional: Codable, Identifiable {
    let id: Int
    let name: String
    let expertise: [String]
    let languages: [String]
    let rating: Int
    let ratingCount: Int
    let profilePictureURL: URL?
    let aboutMe: String?
}
