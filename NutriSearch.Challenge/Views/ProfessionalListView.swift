//
//  ProfessionalListView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

struct ProfessionalListView: View {
    
    @Environment(ProfessionalsViewModel.self) private var viewModel
    
    var body: some View {
        List {
            switch viewModel.state {
            case .none, .loading:
                ProgressView("Searching for Professionals")
                    .frame(maxWidth: .infinity, minHeight: 100)
            case .success:
                ForEach(viewModel.professionals) { professional in
                    ProfessionalCardView(professional: professional)
                }
            case .failed:
                ContentUnavailableView {
                    Text("Couldn't find any professionals")
                } description: {
                    Button("Retry") {
                        viewModel.searchProfessionals()
                    }
                }
            }
            
        }
        .onAppear {
            viewModel.searchProfessionals()
        }
    }
}

#Preview {
    ProfessionalListView()
        .environment(ProfessionalsViewModel(networkClient: NetworkClient()))
}
