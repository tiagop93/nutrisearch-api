//
//  ProfessionalsViewModel.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 03/04/2025.
//

import Foundation
import Combine

@Observable
@MainActor
class SearchProfessionalsViewModel: BaseViewModel {
    
    // MARK: Properties
    
    @ObservationIgnored
    private let networkClient: NetworkService
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    /// Workaround due to the @Observable macro limitation that doesn't allow to directly create a combine pipeline on the sortOption.
    @ObservationIgnored
    var sortOption$ = CurrentValueSubject<SortOption, Never>(.bestMatch)
    
    var professionals: [Professional] = []
    var sortOption: SortOption = .bestMatch {
        didSet { sortOption$.send(sortOption) }
    }
    
    // MARK: Initialization
    
    init(networkClient: NetworkService) {
        self.networkClient = networkClient
        
        super.init()
        setupBindings()
    }
    
    private func setupBindings() {
        sortOption$
            .dropFirst()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .sink { [weak self] newSortOption in
                guard let self = self else { return }
                Task {
                    self.searchProfessionals()
                }
            }
            .store(in: &cancellables)
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
