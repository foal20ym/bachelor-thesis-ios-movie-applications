import Foundation
import Combine

class MovieViewModel: ObservableObject {
    @Published var trendingMovies: [Movie] = []
    @Published var popularMovies: [Movie] = []
    @Published var searchResults: [Movie] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var searchText = ""
    @Published var watchlist: Set<Int> = []
    
    private var cancellables = Set<AnyCancellable>()
    private let apiService = APIService.shared
    
    init() {
        setupSearchSubscription()
        loadWatchlist()
    }
    
    private func setupSearchSubscription() {
        $searchText
            .removeDuplicates()
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] searchText in
                self?.searchMovies(query: searchText)
            }
            .store(in: &cancellables)
    }
    
    func loadTrendingMovies() {
        isLoading = true
        errorMessage = nil
        let urlString = APIEndpoints.trendingMoviesURL
        apiService.fetchMovies(url: urlString) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let movieResponse):
                self?.trendingMovies = movieResponse.results
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func loadPopularMovies() {
        isLoading = true
        errorMessage = nil
        let urlString = APIEndpoints.popularMoviesURL
        apiService.fetchMovies(url: urlString) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let movieResponse):
                self?.popularMovies = movieResponse.results
            case .failure(let error):
                self?.errorMessage = error.localizedDescription
            }
        }
    }
    
    func searchMovies(query: String) {
        print("Searching for: \(query)")
        guard !query.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            self.searchResults = []
            print("Query is empty, clearing search results.")
            return
        }
        isLoading = true
        let urlString = APIEndpoints.searchMoviesURL(for: query)
        print("URL for search: \(urlString)") // Debug print
        apiService.fetchMovies(url: urlString) { [weak self] result in
            DispatchQueue.main.async {
                self?.isLoading = false
                switch result {
                case .success(let movieResponse):
                    print("Found \(movieResponse.results.count) results.")
                    self?.searchResults = movieResponse.results
                case .failure(let error):
                    self?.errorMessage = error.localizedDescription
                    print("Search error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func toggleWatchlist(movieId: Int) {
        if watchlist.contains(movieId) {
            print("Removing movie ID \(movieId) from watchlist")
            watchlist.remove(movieId)
        } else {
            print("Adding movie ID \(movieId) to watchlist")
            watchlist.insert(movieId)
        }
       // saveWatchlist()
    }

    
    func isMovieInWatchlist(_ movieId: Int) -> Bool {
        return watchlist.contains(movieId)
    }
    
    private func loadWatchlist() {
        if let data = UserDefaults.standard.data(forKey: "watchlist"),
           let storedWatchlist = try? JSONDecoder().decode(Set<Int>.self, from: data) {
            watchlist = storedWatchlist
        }
    }
    
    /*private func saveWatchlist() {
        if let data = try? JSONEncoder().encode(watchlist) {
            UserDefaults.standard.set(data, forKey: "watchlist")
        }
    }*/
    
    func fetchMovieCredits(movieId: Int) {
        let urlString = "https://api.themoviedb.org/3/movie/\(movieId)/credits?api_key=b6aa980ddd20798802c7cc95ed96a3ac&language=en-US"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let creditsResponse = try? JSONDecoder().decode(CreditsResponse.self, from: data) {
                DispatchQueue.main.async {
                    if let index = self.trendingMovies.firstIndex(where: { $0.id == movieId }) {
                        self.trendingMovies[index].cast = creditsResponse.cast
                    } else if let index = self.popularMovies.firstIndex(where: { $0.id == movieId }) {
                        self.popularMovies[index].cast = creditsResponse.cast
                    } else if let index = self.searchResults.firstIndex(where: { $0.id == movieId }) {
                        self.searchResults[index].cast = creditsResponse.cast
                    }
                }
            }
        }.resume()
    }

}

extension MovieViewModel {
    var likedMovies: [Movie] {
        let allMovies = trendingMovies + popularMovies + searchResults
        return allMovies.filter { watchlist.contains($0.id) }
    }
}

struct CreditsResponse: Codable {
    let cast: [CastMember]
}




