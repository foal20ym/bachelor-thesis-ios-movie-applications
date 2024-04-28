//
//  CastProfiles.swift
//  movieApp
//
//  Created by Alexander Forsanker on 3/4/24.
//

import Foundation

struct CastProfile: Decodable, Identifiable {
    let birthday: String?
    let id: Int
    let name: String
    let profile_path: String?

    var photoUrl: URL? {
        let baseURL = URL(string: "https://image.tmdb.org/t/p/w200")
        return baseURL?.appending(path: profile_path ?? "")
    }
}
