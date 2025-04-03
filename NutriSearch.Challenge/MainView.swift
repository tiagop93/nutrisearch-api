//
//  ContentView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

struct MainView: View {
    
    @State private var viewModel = SearchProfessionalsViewModel(networkClient: NetworkClient())
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                DropdownView()
                
                Spacer()
                
                ProfessionalListView()
                
            }
            .navigationTitle("NutriSearch")
            .navigationBarTitleDisplayMode(.inline)
        }
        .environment(viewModel)
    }
}

#Preview {
    MainView()
}
