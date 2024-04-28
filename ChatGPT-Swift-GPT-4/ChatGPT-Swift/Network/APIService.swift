import Foundation

class APIService {
    static let shared = APIService()
    
    func fetchMovies(url: String, completion: @escaping (Result<MovieResponse, Error>) -> Void) {
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else { return }
            
            do {
                let moviesResponse = try JSONDecoder().decode(MovieResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(moviesResponse))
                }
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
