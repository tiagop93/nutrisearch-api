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
            case .success:
                ForEach(viewModel.professionals) { professional in
                    NavigationLink {
                        ProfessionalDetailsView(professionalId: professional.id)
                    } label: {
                        ProfessionalCardView(professional: professional)
                    }
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
            if firstTime {
                viewModel.searchProfessionals()
                firstTime = false
            }
        }
    }
}

#Preview {
    ProfessionalListView()
        .environment(SearchProfessionalsViewModel(networkClient: NetworkClient()))
}
