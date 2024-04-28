//
//  MovieCredits.swift
//  movieApp
//
//  Created by Alexander Forsanker on 3/4/24.
//

import Foundation

struct MovieCredits: Decodable {
    let id: Int
    let cast: [Cast]

    struct Cast: Decodable, Identifiable {
        let name: String
        let id: Int
        let character: String
        let order: Int
    }
}
