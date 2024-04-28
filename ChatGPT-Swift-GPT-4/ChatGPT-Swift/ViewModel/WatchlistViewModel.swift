import Foundation

import Foundation

class WatchlistViewModel: ObservableObject {
    @Published var watchlist: [Movie] = []

    private var localWatchlist: [Movie] = []

    init() {
        loadWatchlist()
    }

    func addMovieToWatchlist(_ movie: Movie) {
        if watchlist.contains(where: { $0.id == movie.id }) {
            print("Movie already in watchlist.")
            return
        }
        print("Adding movie to watchlist: \(movie.title)")
        watchlist.append(movie)
        saveWatchlist()
    }

    func removeMovieFromWatchlist(_ movie: Movie) {
        watchlist.removeAll { $0.id == movie.id }
        saveWatchlist()
    }

    private func loadWatchlist() {
        watchlist = localWatchlist
    }

    private func saveWatchlist() {
        localWatchlist = watchlist
    }
}

extension Movie: Equatable {
    static func == (lhs: Movie, rhs: Movie) -> Bool {
        lhs.id == rhs.id
    }
}


