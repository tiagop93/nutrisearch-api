//
//  ImageView.swift
//  NutriSearch.Challenge
//
//  Created by Tiago Pereira on 02/04/2025.
//


import SwiftUI

struct PhotoView: View {
    
    let url: URL?
    
    var body: some View {
        Group {
            if let imageURL = url {
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
