import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: MovieViewModel

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                
                    if viewModel.searchText.isEmpty {
                        movieSection(title: "Trending Movies", movies: viewModel.trendingMovies, isHorizontal: true)
                            .accessibilityIdentifier("trendingScrollView")
                        movieSection(title: "Popular Movies", movies: viewModel.popularMovies, isHorizontal: true)
                            .accessibilityIdentifier("popularScrollView")
                    } else {

                        movieSection(title: "Search Results", movies: viewModel.searchResults, isHorizontal: false)
                    }
                }
            }
            .navigationTitle("Movies")
            .searchable(text: $viewModel.searchText, prompt: "Search Movies")
            .onAppear {
                if viewModel.trendingMovies.isEmpty && viewModel.popularMovies.isEmpty {
                    viewModel.loadTrendingMovies()
                    viewModel.loadPopularMovies()
                }
            }
        }
    }

    @ViewBuilder
    private func movieSection(title: String, movies: [Movie], isHorizontal: Bool = true) -> some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .padding(.leading, 15)
                .padding(.top, 5)

            if isHorizontal {
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 20) {
                        movieRows(movies: movies)
                    }
                    .padding(.leading, 15)
                }
                .frame(height: 200)
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack {
                        movieRows(movies: movies)
                    }
                    .padding(.leading, 15)
                }
            }
        }
    }

    @ViewBuilder
    private func movieRows(movies: [Movie]) -> some View {
        ForEach(movies) { movie in
            HStack {
                NavigationLink(destination: MovieDetailView(movie: movie).environmentObject(viewModel)) {
                    MovieRow(movie: movie)
                }
                .frame(width: 240, height: 200)
                
                Button(action: {
                    viewModel.toggleWatchlist(movieId: movie.id)
                }) {
                    Image(systemName: viewModel.isMovieInWatchlist(movie.id) ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.isMovieInWatchlist(movie.id) ? .red : .gray)
                }
                .buttonStyle(BorderlessButtonStyle())
                .frame(width: 60, height: 200)
            }
        }
    }
}
