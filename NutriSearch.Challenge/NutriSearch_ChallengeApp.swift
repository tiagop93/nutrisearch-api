//
//  NutriSearch_ChallengeApp.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

@main
struct NutriSearch_ChallengeApp: App {
    
    private let networkReachability = DefaultNetworkReachability()
    private let networkStatusObserver: NetworkStatusObserver
    private let viewModel: SearchProfessionalsViewModel
    
    init() {
        self.networkStatusObserver = NetworkStatusObserver(reachability: networkReachability)
        self.viewModel = SearchProfessionalsViewModel(networkClient: NetworkClient(reachability: networkReachability))
    }
    
    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(networkStatusObserver)
                .environment(viewModel)
        }
    }
}
