//
//
//  Created by XX on 2024-04-12.
//

import SwiftUI

struct MovieRow: View {
    let movie: Movie
    
    var body: some View {
        HStack {
            if let posterURL = movie.posterURL {
                AsyncImage(url: posterURL) { phase in
                    switch phase {
                    case .success(let image):
                        image.resizable()
                             .aspectRatio(contentMode: .fill)
                             .frame(width: 100, height: 150)
                             .cornerRadius(8)
                    case .failure:
                        Image(systemName: "film")
                             .frame(width: 100, height: 150)
                    case .empty:
                        ProgressView()
                             .frame(width: 100, height: 150)
                    @unknown default:
                        EmptyView()
                    }
                }
            }
            VStack(alignment: .leading) {
                Text(movie.title)
                    .font(.headline)
                Text(movie.overview)
                    .font(.subheadline)
                    .lineLimit(3)
            }
        }
    }
}
