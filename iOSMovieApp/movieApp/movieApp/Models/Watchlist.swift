//
//  Watchlist.swift
//  movieApp
//
//  Created by Alexander Forsanker on 3/4/24.
//

import Foundation

struct Watchlist: Decodable, Identifiable {
    let id: Int
    let movie: [Movie]
}
