//
//  MovieDetailsViewModel.swift
//  movieApp
//
//  Created by Alexander Forsanker on 2/28/24.
//

import Foundation
import SwiftUI

@MainActor
class MovieDetailsViewModel: ObservableObject {
    
    @Published var credits: MovieCredits?
    @Published var cast: [MovieCredits.Cast] = []
    @Published var castProfiles: [CastProfile] = []
    
    func movieCredits(for movieID: Int) async {
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(movieID)/credits?api_key=\(MovieDiscoverViewModel.API_KEY)&language=en-US")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let credits = try JSONDecoder().decode(MovieCredits.self, from: data)
            self.credits = credits
            self.cast = credits.cast.sorted(by: { $0.order < $1.order})
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func loadCastProfiles() async {
        do {
            for member in cast {
                let url = URL(string: "https://api.themoviedb.org/3/person/\(member.id)?api_key=\(MovieDiscoverViewModel.API_KEY)&language=en-US")!
                let (data, _) = try await URLSession.shared.data(from: url)
                let profile = try JSONDecoder().decode(CastProfile.self, from: data)
                castProfiles.append(profile)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
