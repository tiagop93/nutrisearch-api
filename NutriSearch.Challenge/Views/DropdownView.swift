//
//  DropdownView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

struct DropdownView: View {
    
    @State private var selectedSortOption: SortOption = .bestMatch
    
    var body: some View {
        VStack {
            Picker("Sort", selection: $selectedSortOption) {
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
}
