import Foundation

// MovieResponse to handle the list of movies and pagination
struct MovieResponse: Codable {
    let page: Int
    let results: [Movie]
}

struct Movie: Identifiable, Codable {
    var id: Int
    var title: String
    var releaseDate: String
    var voteAverage: Double
    var voteCount: Int
    var overview: String
    var backdropPath: String?
    var posterPath: String?

    var backdropURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(backdropPath ?? "")")
    }
    var posterURL: URL? {
        URL(string: "https://image.tmdb.org/t/p/w500\(posterPath ?? "")")
    }

    var cast: [CastMember] = []

    private enum CodingKeys: String, CodingKey {
        case id
        case backdropPath = "backdrop_path"
        case title
        case releaseDate = "release_date"
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
        case overview
        case posterPath = "poster_path"
    }
}


enum CodingKeys: String, CodingKey {
    case id
    case backdropPath = "backdrop_path"
    case originalTitle = "original_title"
    case overview
    case posterPath = "poster_path"
    case title
    case releaseDate = "release_date"
    case voteAverage = "vote_average"
    case voteCount = "vote_count"
}

