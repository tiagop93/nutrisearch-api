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
                // Profile Image
                PhotoView(url: professional.profilePictureURL)
                
                // Details
                VStack(alignment: .leading, spacing: 4) {
                    NameView(name: professional.name)
                    RatingView(rating: professional.rating, ratingCount: professional.ratingCount)
                    LanguagesView(languages: professional.languages)
                }
                
                Spacer()
            }
            
            ExpertiseView(expertise: professional.expertise)
        }
        .padding()
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
        
        var body: some View {
            HStack {
                ForEach(expertise, id: \.self) { expertise in
                    Text(expertise)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(12)
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
        profilePictureURL: URL(string: "https://example.com/image.jpg"),
        aboutMe: nil
    )
    
    ProfessionalCardView(professional: mockProfessional)
}
