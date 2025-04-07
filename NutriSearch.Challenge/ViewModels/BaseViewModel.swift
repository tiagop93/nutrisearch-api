//
//  BaseViewModel.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 03/04/2025.
//

import Foundation

@Observable
class BaseViewModel {
    
    // MARK: - State Enum
    
    enum State: Equatable {
        case none
        case loading
        case success
        case failed
    }
    
    // MARK: Network State Enum
    
    enum NetworkState: Equatable {
        case online
        case offline
        
        var isOffline: Bool {
            return self == .offline
        }
    }
    
    // MARK: - Properties
    
    var state: State = .none
    var networkState: NetworkState = .online
    
}
