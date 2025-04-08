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
    
    // MARK: - Properties
    
    @ObservationIgnored
    private let networkClient: NetworkService
    
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    
    @ObservationIgnored
    var sortOption$ = CurrentValueSubject<SortOption, Never>(.bestMatch)
    
    // MARK: - Pagination
    
    @ObservationIgnored var currentPage = 0
    @ObservationIgnored var itemsPerPage = 4
    @ObservationIgnored var totalItems = 0
    @ObservationIgnored var isLoadingMore = false
    
    @ObservationIgnored
    var currentOffset: Int {
        currentPage * itemsPerPage
    }
    
    // MARK: - Published Properties
    
    var professionals: [Professional] = []
    
    var sortOption: SortOption = .bestMatch {
        didSet { sortOption$.send(sortOption) }
    }
    
    var hasMorePages: Bool {
        professionals.count < totalItems
    }
    
    // MARK: - Init
    
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
                    await self.searchProfessionals(isInitialLoad: true)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    func searchProfessionals(isInitialLoad: Bool = true) async {
        if isInitialLoad {
            state = .loading
            currentPage = 0
        } else if isLoadingMore || !hasMorePages {
            return
        }
        
        if !isInitialLoad {
            isLoadingMore = true
        }
        
        defer {
            // Execute at the end of scope
            if !isInitialLoad {
                isLoadingMore = false
            }
        }
        
        do {
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
        } catch {
            print("Error searching professionals: \(error)")
            state = .failed
        }
    }
    
    func loadMoreProfessionals() async {
        guard !isLoadingMore && hasMorePages else { return }
        currentPage += 1
        await searchProfessionals(isInitialLoad: false)
    }
}
