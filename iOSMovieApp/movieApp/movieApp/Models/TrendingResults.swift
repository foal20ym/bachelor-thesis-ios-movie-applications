//
//  TrendingResult.swift
//  movieApp
//
//  Created by Alexander Forsanker on 2/15/24.
//

import Foundation

struct TrendingResults: Decodable {
    let page: Int
    let results: [Movie]
    let total_pages: Int
    let total_results: Int
}
