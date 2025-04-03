//
//  NetworkClient.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 03/04/2025.
//

import Foundation

// MARK: - NutriSearch API Client

struct NetworkClient: NetworkService {
    
    // MARK: Properties
    
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: Network Methods
    
    func request<T>(endpoint: Endpoint, queryItems: [URLQueryItem]?) async throws -> T where T : Decodable {
        guard let endpointUrl = endpoint.url(), var urlComponents = URLComponents(url: endpointUrl, resolvingAgainstBaseURL: true) else {
            throw NetworkError.invalidURL
        }
        
        if let queryItems = queryItems {
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        let request = URLRequest(url: url)
        
        let (data, response) = try await session.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let jsonDecoder = JSONDecoder.defaultDecoder
            return try jsonDecoder.decode(T.self, from: data)
        } catch {
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
        
        return try await request(endpoint: Endpoint.professionalsSearch, queryItems: queryItems)
    }
    
    func professionalDetails(id: Int) async throws -> Professional {
        try await request(endpoint: Endpoint.professionalDetails(id: id), queryItems: nil)
    }
}
