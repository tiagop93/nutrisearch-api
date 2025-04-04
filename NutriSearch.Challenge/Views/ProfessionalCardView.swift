//
//  ProfessionalCard.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//

import SwiftUI

struct ProfessionalCardView: View {
    
    let professional: Professional
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top, spacing: 12) {
                PhotoView(url: professional.profilePictureURL)
                
                VStack(alignment: .leading, spacing: 4) {
                    NameView(name: professional.name)
                    RatingView(rating: professional.rating, ratingCount: professional.ratingCount)
                    LanguagesView(languages: professional.languages)
                }
                
                Spacer()
            }
            
            ExpertiseView(expertise: professional.expertise)
        }
        .padding(.vertical, 16)
    }
}

// MARK: - Professional Card Components

extension ProfessionalCardView {
    
    struct LanguagesView: View {
        
        let languages: [String]
        
        var body: some View {
            HStack(alignment: .center, spacing: 4) {
                Image(systemName: "globe")
                    .font(.system(size: 12))
                    .foregroundColor(.gray)
                
                Text(languages.joined(separator: ", "))
                    .font(.subheadline)
                    .foregroundColor(.primary)
            }
        }
    }
    
    struct ExpertiseView: View {
        
        let expertise: [String]
        private let idealItemCount = 2
        
        var body: some View {
            ViewThatFits(in: .horizontal) {
                // All in one line
                tagsRow(items: expertise)
                
                // Split in 2 per line
                VStack(alignment: .leading, spacing: 8) {
                    tagsRow(items: Array(expertise.prefix(idealItemCount)))
                    if expertise.count > idealItemCount {
                        tagsRow(items: Array(expertise.dropFirst(idealItemCount)))
                    }
                }
            }
        }
        
        private func tagsRow(items: [String]) -> some View {
            HStack {
                ForEach(items, id: \.self) { item in
                    Text(item)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 8)
                        .background(.gray.opacity(0.2))
                        .cornerRadius(12)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    let mockProfessional = Professional(
        id: 1,
        name: "Emma Smith",
        expertise: ["Weight Loss", "Nutrition", "Sports Nutrition", "Sports Nutrition", "Sports Nutrition"],
        languages: ["English", "Spanish"],
        rating: 4,
        ratingCount: 125,
        profilePictureURL: URL(string: "https://example.com/image.jpg"),
        aboutMe: nil
    )
    
    ProfessionalCardView(professional: mockProfessional)
}
