//
//  ProfessionalListView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

struct ProfessionalListView: View {
    
    @Environment(SearchProfessionalsViewModel.self) private var viewModel
    @State private var firstTime = true
    
    var body: some View {
        List {
            switch viewModel.state {
            case .none, .loading:
                ProgressView("Searching for Professionals")
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .id(UUID())
            case .success:
                ForEach(viewModel.professionals) { professional in
                    NavigationLink {
                        ProfessionalDetailsView(professionalId: professional.id)
                    } label: {
                        ProfessionalCardView(professional: professional)
                    }
                }
                
                if viewModel.hasMorePages {
                    loadMoreView
                }
            case .failed:
                ContentUnavailableView {
                    Text("Couldn't find any professionals")
                } description: {
                    Button("Retry") {
                        Task {
                                await viewModel.searchProfessionals()
                            }
                    }
                }
            }
            
        }
        .task {
            if firstTime {
                await viewModel.searchProfessionals()
                firstTime = false
            }
        }
    }
}

extension ProfessionalListView {
    
    private var loadMoreView: some View {
        Group {
            if viewModel.isLoadingMore {
                ProgressView()
                    .frame(maxWidth: .infinity, minHeight: 100)
                    .padding()
            } else {
                // Invisible view that triggers loading more when it "appears"
                Color.clear
                    .frame(height: 20)
                    .task {
                        await viewModel.loadMoreProfessionals()
                    }
            }
        }
    }
}

#Preview {
    ProfessionalListView()
        .environment(SearchProfessionalsViewModel(networkClient: MockNetworkClient()))
}
