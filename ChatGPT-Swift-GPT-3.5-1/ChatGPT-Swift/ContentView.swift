import SwiftUI

struct ContentView: View {
    @StateObject var filmModel = FilmModel()
    @State private var selectedTab: Tab = .movies
    @State private var searchText: String = ""
    
    enum Tab {
        case movies
        case otherView
        case search
    }
    
    var body: some View {
            NavigationView {
                VStack {
                    if selectedTab == .movies {
                        MoviesView(filmModel: filmModel)
                    } else if selectedTab == .otherView {
                        OtherView().environmentObject(filmModel) // Inject FilmModel as environment object
                    } else if selectedTab == .search {
                        SearchView(searchText: $searchText, onSearch: search, filmModel: filmModel)
                    }
                }
                .navigationTitle(selectedTab.title)
                .toolbar {
                    ToolbarItem(placement: .bottomBar) {
                        TabBar(selectedTab: $selectedTab)
                    }
                }
            }
            .onAppear {
                Task {
                    await filmModel.loadTrending()
                    await filmModel.loadPopular()
                }
            }
            .environmentObject(filmModel) // Inject FilmModel as environment object
        }
    
    func search() {
        Task {
            await filmModel.loadSearched(query: searchText)
        }
    }
}

struct MoviesView: View {
    @ObservedObject var filmModel: FilmModel

    var body: some View {
        ScrollView {
            Text("Trending")
                .font(.headline)
                .foregroundColor(.black)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(filmModel.Movies, id: \.id) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieView(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .accessibilityIdentifier("trendingScrollView")
            
            Text("Popular")
                .font(.headline)
                .foregroundColor(.black)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(filmModel.popular, id: \.id) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieView(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
                .padding()
            }
            .accessibilityIdentifier("popularScrollView")
            
        }
    }
}

struct MovieView: View {
    let movie: Movie

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            if let backdropURL = movie.backdropURL {
                AsyncImage(url: backdropURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 150) // Set the desired height for the image
                .cornerRadius(10)
            }
            Text(movie.title)
                .font(.title)
                .foregroundColor(.primary)
            Text(movie.overview)
                .foregroundColor(.secondary)
        }
        .frame(width: 300, height: 200)
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
}

struct MovieDetailView: View {
    let movie: Movie
    @EnvironmentObject var filmModel: FilmModel // Add environment object

    var body: some View {
        VStack {
            if let backdropURL = movie.backdropURL {
                AsyncImage(url: backdropURL) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(height: 200) // Set the desired height for the image
                .cornerRadius(10)
                .padding()
            }
            Text(movie.title)
                .font(.title)
                .padding()
            Text(movie.overview)
                .padding()
            
            // Display actors for the specified movie
            if let credits = filmModel.credits {
                ScrollView {
                    LazyVStack {
                        ForEach(credits.cast) { actor in
                            ActorRow(actor: actor)
                        }
                    }
                }
            } else {
                ProgressView("Loading Actors...")
            }
            
            Button("Add to Watchlist") {
                filmModel.addToWatchlist(movie: movie)
            }
            Button("Remove from Watchlist") {
                filmModel.removeFromWatchlist(movie: movie)
            }
            Spacer()
        }
        .navigationTitle(movie.title)
        .onAppear {
            filmModel.loadActors(movieID: movie.id)
        }
    }
}

struct ActorRow: View {
    let actor: CreditsResponse.Cast
    
    var body: some View {
        HStack {
            Text(actor.name)
            Spacer()
            Text(actor.character)
        }
        .padding(.horizontal)
    }
}

struct OtherView: View {
    @EnvironmentObject var filmModel: FilmModel // Add environment object

    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(filmModel.watchlist, id: \.id) { movie in
                    NavigationLink(destination: MovieDetailView(movie: movie)) {
                        MovieView(movie: movie)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
        .navigationTitle("Watchlist")
    }
}

struct TabBar: View {
    @Binding var selectedTab: ContentView.Tab

    var body: some View {
        HStack {
            Spacer()

            Button(action: {
                selectedTab = .movies
            }) {
                VStack {
                    Image(systemName: "film")
                    Text("Movies")
                }
            }
            .padding()

            Spacer()

            Button(action: {
                selectedTab = .otherView
            }) {
                VStack {
                    Image(systemName: "square.grid.2x2")
                    Text("Other View")
                }
            }
            .padding()
            .accessibilityIdentifier("watchListTab")

            Spacer()

            Button(action: {
                selectedTab = .search
            }) {
                VStack {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            }
            .padding()
            .accessibilityIdentifier("searchTab")

            Spacer()
        }
        .foregroundColor(.accentColor)
    }
}

extension ContentView.Tab {
    var title: String {
        switch self {
        case .movies:
            return "Movies"
        case .otherView:
            return "Other View"
        case .search:
            return "Search"
        }
    }
}

struct SearchView: View {
    @Binding var searchText: String
    var onSearch: () -> Void
    
    @ObservedObject var filmModel: FilmModel // Add FilmModel to fetch search results
    
    var body: some View {
        VStack {
            SearchBar(text: $searchText, onSearch: onSearch)
                .padding(.horizontal)
                .accessibilityIdentifier("searchBar")
            
            ScrollView {
                LazyVStack {
                    ForEach(filmModel.searchedMovies, id: \.id) { movie in
                        NavigationLink(destination: MovieDetailView(movie: movie)) {
                            MovieView(movie: movie)
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String
    var onSearch: () -> Void

    var body: some View {
        HStack {
            TextField("Search", text: $text, onCommit: {
                onSearch()
            })
            .textFieldStyle(RoundedBorderTextFieldStyle())

            Button(action: {
                onSearch()
            }) {
                Text("Search")
            }
            .padding(.horizontal)
            
        }
    }
}


#Preview {
    ContentView()
}
