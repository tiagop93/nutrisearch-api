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
    
    // MARK: Pagination
    
    @ObservationIgnored
    var currentPage = 0
    @ObservationIgnored
    var itemsPerPage = 4
    @ObservationIgnored
    var totalItems = 0
    @ObservationIgnored
    var isLoadingMore = false
    @ObservationIgnored
    var currentOffset: Int {
        currentPage * itemsPerPage
    }
    
    // MARK: Published Properties
    
    var professionals: [Professional] = []
    var sortOption: SortOption = .bestMatch {
        didSet { sortOption$.send(sortOption) }
    }
    var hasMorePages: Bool {
        professionals.count < totalItems
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
    
    func searchProfessionals(isInitialLoad: Bool = true) {
        if isInitialLoad {
            state = .loading
            currentPage = 0
        } else if isLoadingMore || !hasMorePages {
            return
        }
        
        if !isInitialLoad {
            isLoadingMore = true
        }
        
        Task {
            do {
                print("Searching for professionals")
                let searchResponse = try await networkClient.searchProfessionals(
                    limit: itemsPerPage,
                    offset: currentOffset,
                    sortBy: sortOption.apiParameter
                )
                
                totalItems = searchResponse.count
                
                if isInitialLoad {
                    professionals = searchResponse.professionals
                } else {
                    professionals.append(contentsOf: searchResponse.professionals)
                }
                
                state = .success
                
                if !isInitialLoad {
                    isLoadingMore = false
                }
            } catch {
                print("Error searching for professionals: \(error.localizedDescription)")
                state = .failed
                
                if !isInitialLoad {
                    isLoadingMore = false
                }
            }
        }
    }

    func loadMoreProfessionals() {
        guard !isLoadingMore && hasMorePages else { return }
        currentPage += 1
        searchProfessionals(isInitialLoad: false)
    }
}
