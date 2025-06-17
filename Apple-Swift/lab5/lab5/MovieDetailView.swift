//
//  MovieDetailView.swift
//  lab5
//
//  Created by Nianwen Dan on 3/9/24.
//

import SwiftUI

struct MovieDetailView: View {
    var name: String
    var genre: String
    var picture: UIImage
    var description: String
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Image(uiImage: picture)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 200)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                VStack {
                    Text(genre)
                    Text(description)
                        .lineLimit(4)
                        .font(.body)
                        .foregroundStyle(.gray)
                        .padding()
                }
            }
            .navigationTitle("Detail")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    MovieDetailView(name: "Movie Title", genre: "Undefined", picture: UIImage(resource: .posterPlaceholder), description: "Description")
}
