//
//  ProfessionalDetailsViewModel.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 03/04/2025.
//

import Foundation

@Observable
@MainActor
class ProfessionalDetailsViewModel: BaseViewModel {
    
    // MARK: Properties
    
    @ObservationIgnored
    private let networkClient: NetworkService
    
    var professional: Professional?
    
    // MARK: Initialization
    
    init(networkClient: NetworkService) {
        self.networkClient = networkClient
    }
    
    // MARK: - Public Methods
    
    func fetchProfessionalDetails(id: Int) async {
        state = .loading
        
        do {
            print("Fetching professional details")
            let professional = try await networkClient.professionalDetails(id: id)
            self.professional = professional
            
            state = .success
        } catch {
            print("Error fetchin professional details: \(error.localizedDescription)")
            state = .failed
        }
        
        
    }
    
}
