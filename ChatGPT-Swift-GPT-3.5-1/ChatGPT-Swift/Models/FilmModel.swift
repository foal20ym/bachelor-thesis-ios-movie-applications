//
//
//  Created by XX on 2024-03-27.
//


import Foundation
@MainActor
class FilmModel: ObservableObject {
    @Published var Movies: [Movie] = []
    @Published var searchedMovies: [Movie] = []
    @Published var watchlist: [Movie] = []
    @Published var credits: CreditsResponse?
    @Published var actors: [CreditsResponse.Cast] = []
    @Published var castProfile: [CastProfile] = []
    @Published var popular: [Movie] = []
    
    func addToWatchlist(movie: Movie) {
        watchlist.append(movie)
    }
    func removeFromWatchlist(movie: Movie) {
        if let index = watchlist.firstIndex(where: { $0.id == movie.id }) {
            watchlist.remove(at: index)
        }
    }
    
    let apiKey = "b6aa980ddd20798802c7cc95ed96a3ac"
    //let urlString = "https://api.themoviedb.org/3/trending/movie/day?api_key=\(apiKey)"
    
    func loadTrending() {
        Task {
            let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(apiKey)")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let trendingResults = try JSONDecoder().decode(MovieResponse.self, from: data)
                Movies = trendingResults.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadPopular() {
        Task {
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(apiKey)")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let popularResults = try JSONDecoder().decode(MovieResponse.self, from: data)
                popular = popularResults.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadSearched(query: String) {
        Task {
            do {
                let escapedQuery = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
                let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(escapedQuery)"
                let url = URL(string: urlString)!
                let (data, _) = try await URLSession.shared.data(from: url)
                let searchResults = try JSONDecoder().decode(MovieResponse.self, from: data)
                searchedMovies = searchResults.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadActors(movieID: Int) {
        Task {
            let creditsURL = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(apiKey)&language=en-US")!
            do {
                let (data, _) = try await URLSession.shared.data(from: creditsURL)
                let creditsResponse = try JSONDecoder().decode(CreditsResponse.self, from: data)
                self.credits = creditsResponse
                self.actors = creditsResponse.cast
                
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    

        func getActorInfo() async {
            // Assuming castIDs is defined somewhere else
            for member in actors {
                let actorURL = URL(string: "https://api.themoviedb.org/3/person/\(member.id)?api_key=\(apiKey)&language=en-US")!
                do {
                    let (actorData, _) = try await URLSession.shared.data(from: actorURL)
                    let actor = try JSONDecoder().decode(CastProfile.self, from: actorData)
                    
                    castProfile.append(actor)
                } catch {
                    print("Error fetching actor info: \(error.localizedDescription)")
                }
            }
        }
    
    
    
    
    
}

