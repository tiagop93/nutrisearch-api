//
//  RatingView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//


import SwiftUI

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