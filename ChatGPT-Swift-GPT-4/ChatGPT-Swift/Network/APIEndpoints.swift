struct APIEndpoints {
    static let apiKey = "b6aa980ddd20798802c7cc95ed96a3ac"
    static let baseURL = "https://api.themoviedb.org/3"
    
    static var trendingMoviesURL: String {
        return "\(baseURL)/trending/movie/day?api_key=\(apiKey)"
    }
    
    static var popularMoviesURL: String {
        return "\(baseURL)/movie/popular?api_key=\(apiKey)"
    }
    
    static func searchMoviesURL(for query: String) -> String {
        return "\(baseURL)/search/movie?api_key=\(apiKey)&query=\(query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")"
    }
    
    static func movieCreditsURL(for movieID: Int) -> String {
        return "\(baseURL)/movie/\(movieID)/credits?api_key=\(apiKey)"
    }
    
    static func castProfileURL(for castMemberID: Int) -> String {
        return "\(baseURL)/person/\(castMemberID)?api_key=\(apiKey)"
    }
}
