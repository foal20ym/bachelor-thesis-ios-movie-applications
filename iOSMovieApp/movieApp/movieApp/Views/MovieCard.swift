//
//  TrendingCard.swift
//  movieApp
//
//  Created by Alexander Forsanker on 2/15/24.
//

import SwiftUI

struct MovieCard: View {
    
    @ObservedObject var vm: MovieWatchlistViewModel
    let movieItem: Movie
    let backgroundColor = Color(red:61/255, green: 61/255, blue: 88/255)
    
    var body: some View {
        ZStack(alignment: .bottom) {
            AsyncImage(url: movieItem.backdropURL) { image in
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 340, height: 200)
            } placeholder: {
                Rectangle().fill(backgroundColor)
                    .frame(width: 340, height: 200)
            }
            
            VStack {
                HStack {
                    Text(movieItem.title)
                        .foregroundColor(.white)
                        .fontWeight(.heavy)
                    Spacer()
                    Button {
                        if vm.isMovieInWatchlist(movie: movieItem) {
                            vm.removeMovieFromWatchlist(movie: movieItem)
                        } else {
                            vm.addMovieToWatchlist(movie: movieItem)
                        }
                    } label: {
                        Image(systemName: vm.isMovieInWatchlist(movie: movieItem) ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                    }
                }
                HStack {
                    Image(systemName: "hand.thumbsup.fill")
                    Text(String(format: "%.1f", movieItem.vote_average))
                    Spacer()
                }
                .foregroundColor(.yellow)
                .fontWeight(.heavy)
            }
            .padding()
            .background(backgroundColor)
        }
        .cornerRadius(10)
    }
}
