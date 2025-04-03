//
//  ProfessionalDetailsView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

struct ProfessionalDetailsView: View {
    
    let professional: Professional
    
    var body: some View {
        VStack {
            HeaderView(professional: professional)
            AboutMeView(text: professional.aboutMe)
                .padding()
            Spacer()
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
    let mockProfessional = Professional(
        id: 1,
        name: "Emma Smith",
        expertise: ["Weight Loss", "Nutrition", "Sports Nutrition"],
        languages: ["English", "Spanish"],
        rating: 4,
        ratingCount: 125,
        profilePictureURL: URL(string: "https://nutrisearch.vercel.app/static/image-1.jpg"),
        aboutMe: "Dr. Sandy Williams is passionate about helping individuals achieve their health goals through personalized nutrition. He works in United States and speaks English, Spanish, and Italian. There is so much more to learn about Dr. Sandy Williams. Give him a call today! You will get a free consultation. Join the thousands of happy clients who have achieved their health goals with Dr. Sandy Williams."
    )
    
    ProfessionalDetailsView(professional: mockProfessional)
}
