import SwiftUI

struct MovieDetailView: View {
    @EnvironmentObject var viewModel: MovieViewModel
    let movie: Movie

    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                if let backdropURL = movie.backdropURL {
                    AsyncImage(url: backdropURL) { image in
                        image.resizable()
                    } placeholder: {
                        Color.gray.opacity(0.3)
                    }
                    .aspectRatio(contentMode: .fit)
                }

                HStack {
                    Text(movie.title)
                        .font(.title)
                        .fontWeight(.bold)

                    Spacer()

                    Button(action: {
                        viewModel.toggleWatchlist(movieId: movie.id)
                    }) {
                        Image(systemName: viewModel.isMovieInWatchlist(movie.id) ? "heart.fill" : "heart")
                            .foregroundColor(viewModel.isMovieInWatchlist(movie.id) ? .red : .gray)
                    }
                    .accessibilityIdentifier("addToWatchListButton")
                }
                .padding(.top)

                Text("Release Date: \(movie.releaseDate)")
                    .font(.subheadline)
                    .padding(.vertical, 2)

                Text("Rating: \(movie.voteAverage, specifier: "%.1f") (\(movie.voteCount) votes)")
                    .font(.subheadline)
                    .padding(.bottom)

                Text(movie.overview)
                    .padding(.bottom)

                Text("Cast")
                    .font(.headline)
                    .padding(.top)
                
                ForEach(Array(movie.cast.enumerated()), id: \.element.id) { index, castMember in
                    HStack {
                        if let photoUrl = castMember.profileURL {
                            AsyncImage(url: photoUrl) { image in
                                image.resizable()
                            } placeholder: {
                                Color.gray.opacity(0.3)
                            }
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                        }
                        VStack(alignment: .leading) {
                            Text(castMember.name)
                                .fontWeight(.bold)
                            Text(castMember.character)
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding(.vertical, 4)
                }
            }
            .padding()
        }
        .navigationTitle("Details")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.fetchMovieCredits(movieId: movie.id)
        }
    }
}
