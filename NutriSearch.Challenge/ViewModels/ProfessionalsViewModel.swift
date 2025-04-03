//
//  ProfessionalsViewModel.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 03/04/2025.
//

import Foundation

@Observable
class ProfessionalsViewModel: BaseViewModel {
    
    // MARK: Properties
    
    @ObservationIgnored private let networkClient: NetworkService
    
    var professionals: [Professional] = []
    var sortOption: SortOption = .bestMatch
    
    // MARK: Initialization
    
    init(networkClient: NetworkService) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    
    func searchProfessionals() {
        state = .loading
        
        Task {
            do {
                print("Searching for professionals")
                let searchResponse = try await networkClient.searchProfessionals(limit: 4, offset: 0, sortBy: sortOption.apiParameter)
                professionals = searchResponse.professionals
                
                state = .success
            } catch {
                print("Error searching for professionals: \(error.localizedDescription)")
                state = .failed
            }
        }
        
    }
}
