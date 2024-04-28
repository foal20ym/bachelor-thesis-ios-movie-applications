import SwiftUI

struct WatchlistView: View {
    @EnvironmentObject var viewModel: MovieViewModel

    var body: some View {
        NavigationView {
            List {
                
                ForEach(viewModel.likedMovies) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(viewModel)) {
                        MovieRow(movie: movie)
                    }
                }
                .onDelete(perform: deleteMovieFromWatchlist)
            }
            .navigationTitle("Watchlist")
        }
    }

    private func deleteMovieFromWatchlist(at offsets: IndexSet) {
        offsets.forEach { index in
            let movie = viewModel.likedMovies[index]
            viewModel.toggleWatchlist(movieId: movie.id)
        }
    }
}

