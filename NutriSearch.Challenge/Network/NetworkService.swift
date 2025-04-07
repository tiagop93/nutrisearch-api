//
//  NetworkService.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 03/04/2025.
//

import Foundation

// MARK: - Network Protocol

protocol NetworkService {
    func request<T: Codable>(endpoint: Endpoint, queryItems: [URLQueryItem]?) async throws -> T
    
    func searchProfessionals(limit: Int, offset: Int, sortBy: String?) async throws -> SearchResponse
    func professionalDetails(id: Int) async throws -> Professional
}

// MARK: - Network errors

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case noInternetConnection
    case decodingError(Error)
}
