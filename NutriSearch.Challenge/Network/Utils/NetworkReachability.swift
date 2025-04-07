//
//  NetworkReachability.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 04/04/2025.
//

import Foundation
import Network
import Combine

protocol NetworkReachability {
    var isConnected: Bool { get }
    var isConnectedPublisher: AnyPublisher<Bool, Never> { get }
}

// MARK: - DefaultNetworkReachability

final class DefaultNetworkReachability: NetworkReachability {
    private let monitor = NWPathMonitor()
    private let queue = DispatchQueue(label: "NetworkMonitor")
    private var currentStatus: Bool {
        didSet {
            isConnectedSubject.send(currentStatus)
        }
    }

    private let isConnectedSubject: CurrentValueSubject<Bool, Never>

    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }

    init() {
        // Get initial path status
        let initialPath = NWPathMonitor().currentPath
        let isInitiallyConnected = initialPath.status == .satisfied

        self.currentStatus = isInitiallyConnected
        self.isConnectedSubject = CurrentValueSubject(isInitiallyConnected)

        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            DispatchQueue.main.async {
                self?.currentStatus = isConnected
            }
        }

        monitor.start(queue: queue)

    }

    var isConnected: Bool {
        currentStatus
    }
}


// MARK: - MockNetworkReachability

final class MockNetworkReachability: NetworkReachability {
    private let isConnectedSubject: CurrentValueSubject<Bool, Never>

    init(isConnected: Bool) {
        self.isConnectedSubject = CurrentValueSubject(isConnected)
    }

    var isConnected: Bool {
        isConnectedSubject.value
    }

    var isConnectedPublisher: AnyPublisher<Bool, Never> {
        isConnectedSubject.eraseToAnyPublisher()
    }
}


