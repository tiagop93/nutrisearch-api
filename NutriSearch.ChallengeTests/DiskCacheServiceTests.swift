//
//  CacheManagerTests.swift
//  NutriSearch.ChallengeTests
//
//  Created by Tiago Pereira on 07/04/2025.
//

import XCTest

@testable import NutriSearch_Challenge

final class DiskCacheServiceTests: XCTestCase {
    
    // MARK: - Properties
    
    private var cacheService: CacheService!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        let tempDirectory = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        cacheService = DiskCacheService(expirationInterval: 60, freshInterval: 10, cacheDirectory: tempDirectory)
    }
    
    override func tearDown() {
        cacheService = nil
    }

    // MARK: - Tests
    
    func testCacheExpirationLogic() {
        let mockData = Professional(id: 1, name: "Test Professional", expertise: [], languages: [], rating: 5, ratingCount: 10, profilePictureURL: nil, aboutMe: nil)
        let cachedResponse = CachedResponse(data: mockData, timestamp: Date())
        
        XCTAssertTrue(cacheService.isFresh(cachedResponse.timestamp))
        
        let oldTimestamp = Date().addingTimeInterval(-120)
        let oldCachedResponse = CachedResponse(data: mockData, timestamp: oldTimestamp)
        XCTAssertTrue(cacheService.isExpired(oldCachedResponse.timestamp))
    }
    
    func testCacheKeyGeneration() {
        let key1 = cacheService.generateCacheKey(for: .professionalsSearch, queryItems: nil)
        let key2 = cacheService.generateCacheKey(for: .professionalDetails(id: 1), queryItems: nil)
        XCTAssertNotEqual(key1, key2, "Different endpoints should generate different keys")
        
        let queryItems1 = [URLQueryItem(name: "limit", value: "10"), URLQueryItem(name: "offset", value: "0")]
        let queryItems2 = [URLQueryItem(name: "limit", value: "10"), URLQueryItem(name: "offset", value: "10")]
        
        let key3 = cacheService.generateCacheKey(for: .professionalsSearch, queryItems: queryItems1)
        let key4 = cacheService.generateCacheKey(for: .professionalsSearch, queryItems: queryItems2)
        XCTAssertNotEqual(key3, key4, "Same endpoint with different query params should generate different keys")
        
        let queryItems3 = [URLQueryItem(name: "offset", value: "0"), URLQueryItem(name: "limit", value: "10")]
        let key5 = cacheService.generateCacheKey(for: .professionalsSearch, queryItems: queryItems3)
        XCTAssertEqual(key3, key5, "Query parameter order shouldn't affect the key")
    }
  
}
