//
//  CacheService.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 04/04/2025.
//

import Foundation

// MARK: - Cache Protocol

protocol CacheService {
    func save<T: Encodable>(_ object: T, forKey key: String) throws
    func load<T: Decodable>(forKey key: String) throws -> T
    func remove(forKey key: String) throws
    func exists(forKey key: String) -> Bool
    func generateCacheKey(for endpoint: Endpoint, queryItems: [URLQueryItem]?) -> String
    func isExpired(_ timestamp: Date) -> Bool
    func isFresh(_ timestamp: Date) -> Bool
    func clearCache() throws
}

// MARK: - Cached Response
struct CachedResponse<T: Codable>: Codable {
    let data: T
    let timestamp: Date
}

// MARK: - Cache Error

enum CacheError: Error {
    case notFound
    case encodingFailed
    case decodingFailed
}
