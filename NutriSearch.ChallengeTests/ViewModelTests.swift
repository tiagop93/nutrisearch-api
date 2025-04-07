//
//  ViewModelTests.swift
//  NutriSearch.ChallengeTests
//
//  Created by Tiago Pereira on 07/04/2025.
//

import XCTest

@testable import NutriSearch_Challenge

@MainActor
final class ViewModelTests: XCTestCase {
    
    // MARK: - Properties
    
    private var networkClient: NetworkService!
    private var viewModel: SearchProfessionalsViewModel!
    
    // MARK: - Setup and Teardown
    
    override func setUp() {
        super.setUp()
        networkClient = MockNetworkClient(shouldSimulateNetworkDelay: true)
        viewModel = SearchProfessionalsViewModel(networkClient: networkClient)
    }
    
    override func tearDown() {
        networkClient = nil
        viewModel = nil
    }
    
    // MARK: - Tests
    
    func testViewModelPaginationFromMockFile() async throws {
        await viewModel.searchProfessionals(isInitialLoad: true)
        
        XCTAssertEqual(viewModel.currentPage, 0, "Current page should be 0")
        XCTAssertFalse(viewModel.professionals.isEmpty, "Should have loaded professionals")
        XCTAssertEqual(viewModel.professionals.count, 4, "Should have loaded 4 professionals")
        XCTAssertGreaterThan(viewModel.totalItems, 4, "Total items should be more than first page")
        XCTAssertTrue(viewModel.hasMorePages, "Should have more pages")
        
        let firstPageProfessionals = viewModel.professionals
        
        await viewModel.loadMoreProfessionals()
        
        // Validate second page was added to the first
        XCTAssertEqual(viewModel.currentPage, 1, "Current page should be 1")
        XCTAssertEqual(viewModel.professionals.count, 8, "Should now have 8 professionals")
        
        for professional in firstPageProfessionals {
            XCTAssertTrue(viewModel.professionals.contains(where: { $0.id == professional.id }),
                         "Professional \(professional.id) from first page should still be present")
        }
    }
    
    func testSortOptionChangesData() async throws {
        await viewModel.searchProfessionals(isInitialLoad: true)
        
        let initialSortOption = viewModel.sortOption
        
        await viewModel.loadMoreProfessionals()
        
        XCTAssertEqual(viewModel.currentPage, 1, "Current page should be 1")
        XCTAssertEqual(viewModel.professionals.count, 8, "Should now have 8 professionals")
        
        let newSortOption: SortOption = .rating
        print("Changing sort option from \(initialSortOption) to \(newSortOption)")
        viewModel.sortOption = newSortOption
        
        try await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        XCTAssertEqual(viewModel.currentPage, 0, "Pagination should reset when sort option changes")
    }
}
