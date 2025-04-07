//
//  OfflineIndicatorView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 04/04/2025.
//

import SwiftUI

struct OfflineIndicatorView: View {
    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "wifi.slash")
                .font(.system(size: 14))
            
            Text("You're offline")
                .font(.subheadline)
                .fontWeight(.medium)
            
            Spacer()
        }
        .foregroundColor(.white)
        .padding(.vertical, 8)
        .padding(.horizontal, 16)
        .background(Color.orange)
        .transition(.move(edge: .top).combined(with: .opacity))
    }
}

// MARK: - Offline Indicator overlay
extension View {
    func offlineIndicator(isOffline: Bool) -> some View {
        self.overlay(
            Group {
                if isOffline {
                    VStack {
                        OfflineIndicatorView()
                        Spacer()
                    }
                }
            },
            alignment: .top
        )
    }
}


#Preview {
    OfflineIndicatorView()
}
