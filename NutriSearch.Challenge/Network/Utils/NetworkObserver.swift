//
//  NetworkObserver.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 04/04/2025.
//

import Foundation
import Combine

@Observable
final class NetworkStatusObserver {
    @ObservationIgnored
    private var cancellables = Set<AnyCancellable>()
    
    var isOffline: Bool = false
    
    init(reachability: NetworkReachability) {
        reachability.isConnectedPublisher
            .map { !$0 }
            .removeDuplicates()
            .debounce(for: .milliseconds(300), scheduler: DispatchQueue.main)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newValue in
                print("📡 Network status changed: \(newValue ? "Offline" : "Online")")
                self?.isOffline = newValue
            }
            .store(in: &cancellables)
    }
}


