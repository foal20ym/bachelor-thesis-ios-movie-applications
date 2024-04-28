import Foundation

// For fetching and decoding cast information from the API
struct CastResponse: Codable {
    let id: Int
    let cast: [CastMember]
}

struct CastMember: Identifiable, Codable {
    var id: Int
    var name: String
    var character: String
    var profilePath: String?

    var profileURL: URL? {
        guard let path = profilePath else { return nil }
        return URL(string: "https://image.tmdb.org/t/p/w200\(path)")
    }

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case character
        case profilePath = "profile_path"
    }
}
