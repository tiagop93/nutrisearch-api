//
//  DiskCache.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 04/04/2025.
//

import Foundation

// MARK: - Disk Cache Manager

class DiskCacheService: CacheService {
    
    // MARK: Properties
    
    private let fileManager = FileManager.default
    private let cacheName = "NutriSearchCache"
    private let expirationInterval: TimeInterval
    private let freshInterval: TimeInterval
    
    // MARK: Initiliazation
    
    init(
        expirationInterval: TimeInterval = 60 * 60 * 24,
        freshInterval: TimeInterval = 60 * 5
    ) {
        self.expirationInterval = expirationInterval
        self.freshInterval = freshInterval
    }
    
    private var cacheDirectory: URL {
        let cachesURL = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)[0]
        let directoryURL = cachesURL.appendingPathComponent(cacheName, isDirectory: true)
        
        // Create directory if it doesn't exist
        if !fileManager.fileExists(atPath: directoryURL.path) {
            try? fileManager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
        
        return directoryURL
    }
    
    private func fileURL(forKey key: String) -> URL {
        return cacheDirectory.appendingPathComponent("\(key).cache")
    }
    
    func save<T: Encodable>(_ object: T, forKey key: String) throws {
        let data = try JSONEncoder().encode(object)
        try data.write(to: fileURL(forKey: key))
    }
    
    func load<T: Decodable>(forKey key: String) throws -> T {
        let fileURL = self.fileURL(forKey: key)
        
        guard fileManager.fileExists(atPath: fileURL.path) else {
            throw CacheError.notFound
        }
        
        let data = try Data(contentsOf: fileURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func remove(forKey key: String) throws {
        let fileURL = self.fileURL(forKey: key)
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
    }
    
    func exists(forKey key: String) -> Bool {
        return fileManager.fileExists(atPath: fileURL(forKey: key).path)
    }
    
    func generateCacheKey(for endpoint: Endpoint, queryItems: [URLQueryItem]?) -> String {
        var key = "\(endpoint)"
        
        if let queryItems = queryItems, !queryItems.isEmpty {
            let queryString = queryItems
                .sorted { $0.name < $1.name }
                .map { item in "\(item.name)=\(item.value ?? "")" }
                .joined(separator: "&")
            
            key += "?\(queryString)"
        }
        
        return key.replacingOccurrences(of: "/", with: "_")
    }
    
    func isExpired(_ timestamp: Date) -> Bool {
        return Date().timeIntervalSince(timestamp) > expirationInterval
    }
    
    func isFresh(_ timestamp: Date) -> Bool {
        return Date().timeIntervalSince(timestamp) < freshInterval
    }
    
    func clearCache() throws {
        let contents = try fileManager.contentsOfDirectory(at: cacheDirectory, includingPropertiesForKeys: nil)
        for url in contents {
            try fileManager.removeItem(at: url)
        }
    }
}
