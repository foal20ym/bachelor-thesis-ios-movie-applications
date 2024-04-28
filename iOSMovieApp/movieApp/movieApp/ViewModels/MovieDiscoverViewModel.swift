//
//  MovieDBViewModel.swift
//  movieApp
//
//  Created by Alexander Forsanker on 2/15/24.
//

import Foundation

@MainActor
class MovieDiscoverViewModel: ObservableObject {
    
    @Published var trending: [Movie] = []
    @Published var popular: [Movie] = []
    @Published var searchResults: [Movie] = []
    static let API_KEY = "b6aa980ddd20798802c7cc95ed96a3ac"

    func loadTrending() {
        Task {
            let url = URL(string: "https://api.themoviedb.org/3/trending/movie/day?api_key=\(MovieDiscoverViewModel.API_KEY)")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
                trending = trendingResults.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func loadPopular() {
        Task {
            let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=\(MovieDiscoverViewModel.API_KEY)")!
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                let popularResults = try JSONDecoder().decode(TrendingResults.self, from: data)
                popular = popularResults.results
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func searchWithMockData(term: String) {
        if let fileUrl = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data = try Data(contentsOf: fileUrl)
                let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
                searchResults = trendingResults.results.filter { $0.title.lowercased().contains(term.lowercased()) }
            } catch {
                print("Error reading mock data:", error.localizedDescription)
            }
        } else {
            print("Data file not found.")
        }
    }
    
    func search(term: String) {
            Task {
                let url = URL(string: "https://api.themoviedb.org/3/search/movie?api_key=\(MovieDiscoverViewModel.API_KEY)&language=en-US&page=1&include_adult=false&query=\(term)"
                    
                    .addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)!)!
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    let trendingResults = try JSONDecoder().decode(TrendingResults.self, from: data)
                    searchResults = trendingResults.results
                } catch {
                    print(error.localizedDescription)
                }
            }
    }
}
