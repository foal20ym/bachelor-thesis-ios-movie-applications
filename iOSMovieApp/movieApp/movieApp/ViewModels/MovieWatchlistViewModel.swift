//
//  MovieWatchlistViewModel.swift
//  movieApp
//
//  Created by Alexander Forsanker on 3/4/24.
//

import Foundation


class MovieWatchlistViewModel: ObservableObject {
    @Published var watchlist: [Movie] = []
    
    func addMovieToWatchlist(movie: Movie) {
        watchlist.append(movie)
        print("Added movie to watchlist: \(movie.title)")
    }
    
    func removeMovieFromWatchlist(movie: Movie) {
        watchlist.removeAll { $0.id == movie.id }
        print("Removed movie from watchlist: \(movie.title)")
    }
    
    func isMovieInWatchlist(movie: Movie) -> Bool {
        return watchlist.contains { $0.id == movie.id }
    }
}
