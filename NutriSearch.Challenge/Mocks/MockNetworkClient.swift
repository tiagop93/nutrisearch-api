//
//  MockNetworkClient.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 07/04/2025.
//

import Foundation

// MARK: - Mock Network Client

struct MockNetworkClient: NetworkService {
    // MARK: Properties
    
    private let bundle: Bundle
    private let shouldSimulateNetworkDelay: Bool
    private let networkDelaySeconds: TimeInterval
    
    // MARK: Initialization
    
    init(
        bundle: Bundle = .main,
        shouldSimulateNetworkDelay: Bool = true,
        networkDelaySeconds: TimeInterval = 0.5
    ) {
        self.bundle = bundle
        self.shouldSimulateNetworkDelay = shouldSimulateNetworkDelay
        self.networkDelaySeconds = networkDelaySeconds
    }
    
    // MARK: - Network Protocol Methods
    
    func request<T>(endpoint: Endpoint, queryItems: [URLQueryItem]?) async throws -> T where T : Decodable, T : Encodable {
        let filename = filenameForEndpoint(endpoint, queryItems: queryItems)
        
        if shouldSimulateNetworkDelay {
            try? await Task.sleep(nanoseconds: UInt64(networkDelaySeconds * 1_000_000_000))
        }
        
        guard let url = bundle.url(forResource: filename, withExtension: "json") else {
            print("Mock file not found: \(filename).json")
            throw NetworkError.invalidURL
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder.defaultDecoder
            return try decoder.decode(T.self, from: data)
        } catch {
            print("Error loading mock data: \(error)")
            throw NetworkError.decodingError(error)
        }
    }
    
    func searchProfessionals(limit: Int = 4, offset: Int = 0, sortBy: String? = nil) async throws -> SearchResponse {
        var queryItems = [
            URLQueryItem(name: NetworkConstants.limit, value: "\(limit)"),
            URLQueryItem(name: NetworkConstants.offset, value: "\(offset)")
        ]
        
        if let sortBy = sortBy {
            queryItems.append(URLQueryItem(name: NetworkConstants.sortBy, value: sortBy))
        }
        
        return try await request(endpoint: .professionalsSearch, queryItems: queryItems)
    }
    
    func professionalDetails(id: Int) async throws -> Professional {
        return try await request(endpoint: .professionalDetails(id: id), queryItems: nil)
    }
    
    // MARK: Helper Methods
    
    private func filenameForEndpoint(_ endpoint: Endpoint, queryItems: [URLQueryItem]?) -> String {
        switch endpoint {
        case .professionalsSearch:
            let limit = queryItems?.first(where: { $0.name == NetworkConstants.limit })?.value ?? "4"
            let offset = queryItems?.first(where: { $0.name == NetworkConstants.offset })?.value ?? "0"
            let sortBy = queryItems?.first(where: { $0.name == NetworkConstants.sortBy })?.value
            
            let page = Int(offset)! / Int(limit)!
            var filename = "professionals_page\(page)"
            
            if let sortBy = sortBy {
                filename += "_\(sortBy)"
            }
            
            return filename
            
        case .professionalDetails(let id):
            return "professional_\(id)"
        }
    }
    
}
