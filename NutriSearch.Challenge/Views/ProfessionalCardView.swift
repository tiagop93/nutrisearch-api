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
                ImageView(imageURL: professional.profilePictureURL)
                
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
    
    struct ImageView: View {
        
        let imageURL: URL?
        
        var body: some View {
            Group {
                if let imageURL = imageURL {
                    AsyncImage(url: imageURL) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        case .failure:
                            Image(systemName: "person.fill")
                                .font(.system(size: 40))
                                .foregroundColor(.blue)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Image(systemName: "person.fill")
                        .font(.system(size: 40))
                        .foregroundColor(.blue)
                }
            }
            .frame(width: 80, height: 80)
            .background(Color.blue.opacity(0.1))
            .cornerRadius(8)
        }
    }
    
    struct NameView: View {
        
        let name: String
        
        var body: some View {
            Text(name)
                .font(.headline)
        }
    }
    
    struct RatingView: View {
        
        let rating: Int
        let ratingCount: Int
        
        var body: some View {
            HStack(alignment: .center, spacing: 2) {
                ForEach(1...5, id: \.self) { index in
                    Image(systemName: index <= rating ? "star.fill" : "star")
                        .foregroundColor(.blue)
                        .font(.system(size: 14))
                }
                
                Text("\(rating)/5 (\(ratingCount))")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
    }
    
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
