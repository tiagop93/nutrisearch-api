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
    
    // MARK: - Properties
    
    var state: State = .none
}
