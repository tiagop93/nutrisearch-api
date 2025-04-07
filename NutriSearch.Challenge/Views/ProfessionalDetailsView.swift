//
//  ProfessionalDetailsView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

struct ProfessionalDetailsView: View {
    
    @Environment(NetworkStatusObserver.self) private var networkObserver
    @State private var viewModel = ProfessionalDetailsViewModel(networkClient: NetworkClient())
    let professionalId: Int
    
    var body: some View {
        VStack {
            switch viewModel.state {
            case .none, .loading:
                ProgressView("Loading the details")
                    .frame(maxWidth: .infinity, minHeight: 100)
            case .success:
                if let professional = viewModel.professional {
                    HeaderView(professional: professional)
                        .offlineIndicator(isOffline: networkObserver.isOffline)
                    AboutMeView(text: professional.aboutMe)
                        .padding()
                    Spacer()
                }
            case .failed:
                ContentUnavailableView {
                    Text("Failed to load the details")
                } description: {
                    Button("Retry") {
                        Task {
                           await viewModel.fetchProfessionalDetails(id: professionalId)
                        }
                    }
                }
            }
        }
        .task {
            await viewModel.fetchProfessionalDetails(id: professionalId)
        }
    }
}

// MARK: - Professional Details Components

extension ProfessionalDetailsView {
    
    struct HeaderView: View {
        
        let professional: Professional
        
        var body: some View {
            ZStack {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .overlay(alignment: .bottom) {
                        Divider()
                            .background(.black)
                            .shadow(color: .black, radius: 5, x: 0, y: 2)
                    }
                
                HStack(alignment: .top, spacing: 16) {
                    PhotoView(url: professional.profilePictureURL)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        NameView(name: professional.name)
                        RatingView(rating: professional.rating, ratingCount: professional.ratingCount)
                    }
                    
                    Spacer()
                }
            }
            .frame(height: 180)
        }
        
    }
    
    struct AboutMeView: View {
        
        let text: String?
        private let fontSize: CGFloat = 17
        
        @State private var showFullAboutMe = false
        @State private var hasTextOverflow = false
        
        var body: some View {
            VStack(alignment: .leading, spacing: 16) {
                Text("About me")
                    .font(.title3)
                    .fontWeight(.bold)
                
                if let aboutMe = text {
                    VStack(alignment: .trailing, spacing: 8) {
                        Text(aboutMe)
                            .font(.system(size: fontSize))
                            .lineLimit(showFullAboutMe ? nil : 5)
                            .background(
                                // Use GeometryReader to detect if text is truncated
                                GeometryReader { geometry in
                                    Color.clear.onAppear {
                                        let textSize = aboutMe.boundingRect(
                                            with: CGSize(
                                                width: geometry.size.width,
                                                height: .greatestFiniteMagnitude
                                            ),
                                            options: .usesLineFragmentOrigin,
                                            attributes: [.font: UIFont.systemFont(ofSize: fontSize)],
                                            context: nil
                                        )
                                        
                                        // Approximation of line height
                                        let fiveLineHeight = UIFont.systemFont(ofSize: fontSize).lineHeight * 5
                                        
                                        if textSize.height > fiveLineHeight {
                                            DispatchQueue.main.async {
                                                self.hasTextOverflow = true
                                            }
                                        }
                                    }
                                }
                            )
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        if hasTextOverflow {
                            Button(action: {
                                withAnimation(.smooth) {
                                    showFullAboutMe.toggle()
                                }
                            }) {
                                HStack {
                                    Text(showFullAboutMe ? "show less" : "show more")
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                    
                                    Image(systemName: showFullAboutMe ? "chevron.up" : "chevron.down")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                }
                                .padding(.trailing)
                            }
                        }
                    }
                }
            }
        }
    }
    
}

#Preview {
    ProfessionalDetailsView(professionalId: 4)
        .environment(NetworkStatusObserver(reachability: MockNetworkReachability(isConnected: false)))
}
