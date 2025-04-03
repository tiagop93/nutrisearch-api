//
//  DropdownView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

struct DropdownView: View {
    
    @Environment(SearchProfessionalsViewModel.self) private var viewModel
    
    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            Picker("Sort", selection: $viewModel.sortOption) {
                ForEach(SortOption.allCases) { option in
                    Text(option.rawValue).tag(option)
                }
            }
            .pickerStyle(.menu)
        }
    }
}

// MARK: - Sort Options

enum SortOption: String, CaseIterable, Identifiable {
    case bestMatch = "Best for You"
    case rating = "Rating"
    case mostPopular = "Most Popular"
    
    var id: String { self.rawValue }
    
    var apiParameter: String {
        switch self {
        case .bestMatch:
            return "best_match"
        case .rating:
            return "rating"
        case .mostPopular:
            return "most_popular"
        }
    }
}

#Preview {
    DropdownView()
        .environment(SearchProfessionalsViewModel(networkClient: NetworkClient()))
}
