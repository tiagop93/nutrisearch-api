//
//  ContentView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

struct MainView: View {
    
    @Environment(NetworkStatusObserver.self) private var networkObserver
    @Environment(SearchProfessionalsViewModel.self) private var viewModel
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                DropdownView()
                    .accessibilityIdentifier("DropdownView")
                
                Spacer()
                
                ProfessionalListView()
                    .offlineIndicator(isOffline: networkObserver.isOffline)
                    .accessibilityIdentifier("ProfessionalListView")
                
            }
            .navigationTitle("NutriSearch")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MainView()
        .environment(NetworkStatusObserver(reachability: MockNetworkReachability(isConnected: true)))
        .environment(SearchProfessionalsViewModel(networkClient: MockNetworkClient(shouldSimulateNetworkDelay: true)))
}
