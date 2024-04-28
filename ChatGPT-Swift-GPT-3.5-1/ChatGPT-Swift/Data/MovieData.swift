//
//
//  Created by XX on 2024-03-27.
//

import Foundation
    struct MovieResponse: Codable {
        let page: Int
        let results: [Movie]
        let totalPages: Int
        let totalResults: Int
        
        private enum CodingKeys: String, CodingKey {
            case page
            case results
            case totalPages = "total_pages"
            case totalResults = "total_results"
        }
    }

    struct Movie: Codable {
        let adult: Bool
        let backdropPath: String?
        let genreIds: [Int]
        let id: Int
        let originalLanguage: String
        let originalTitle: String
        let overview: String
        let popularity: Double
        let posterPath: String?
        let releaseDate: String
        let title: String
        let video: Bool
        let voteAverage: Double
        let voteCount: Int
        
        private enum CodingKeys: String, CodingKey {
            case adult
            case backdropPath = "backdrop_path"
            case genreIds = "genre_ids"
            case id
            case originalLanguage = "original_language"
            case originalTitle = "original_title"
            case overview
            case popularity
            case posterPath = "poster_path"
            case releaseDate = "release_date"
            case title
            case video
            case voteAverage = "vote_average"
            case voteCount = "vote_count"
        }
        
        var backdropURL: URL? {
                guard let backdropPath = backdropPath else {
                    return nil
                }
                return URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath)")
            }
        

}
struct CreditsResponse: Codable {
    let id: Int
    let cast: [Cast]
    
    struct Cast: Codable, Identifiable {
        let id: Int
        let name: String
        let character: String
        let order: Int
    }
}


struct CastProfile: Codable, Identifiable{
    let id: Int
    let name: String
    let profile_path: String?
    let order: Int
}

