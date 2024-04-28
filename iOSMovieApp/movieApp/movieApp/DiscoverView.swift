//
//  ContentView.swift
//  movieApp
//
//  Created by Alexander Forsanker on 2/15/24.
//

import SwiftUI

struct DiscoverView: View {
    
    @StateObject var viewModel = MovieDiscoverViewModel()
    @StateObject var vm = MovieWatchlistViewModel()
    @State var searchText = ""
    let backgroundColorMain = Color(red:39/255, green: 40/255, blue: 59/255)
    let backgroundColor = Color(red:61/255, green: 61/255, blue: 88/255)
    
    var body: some View {
        NavigationStack {
            ScrollView {
                if searchText.isEmpty {
                    
                    if viewModel.trending.isEmpty {
                        Text("No Results")
                    } else {
                        HStack {
                            Text("Trending")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.trending) { trendingItem in
                                    NavigationLink {
                                        MovieDetailView(vm: vm, movie: trendingItem)
                                    } label: {
                                        MovieCard(vm: vm, movieItem: trendingItem)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .accessibilityIdentifier("trendingScrollView")
                    }
                    
                    if viewModel.trending.isEmpty {
                        Text("No Results")
                    } else {
                        HStack {
                            Text("Popular")
                                .font(.title)
                                .foregroundColor(.white)
                                .fontWeight(.heavy)
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                ForEach(viewModel.popular) { popularItem in
                                    NavigationLink {
                                        MovieDetailView(vm: vm, movie: popularItem)
                                    } label: {
                                        MovieCard(vm: vm, movieItem: popularItem)
                                    }
                                }
                            }
                            .padding(.horizontal)
                        }
                        .accessibilityIdentifier("popularScrollView")
                    }
                } else {
                    LazyVStack() {
                        ForEach(viewModel.searchResults) { item in
                            NavigationLink {
                                MovieDetailView(vm: vm, movie: item)
                            } label: {
                                HStack {
                                    AsyncImage(url: item.backdropURL) { image in
                                        image
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 80, height: 120)
                                        
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 80, height: 120)
                                    }
                                    .clipped()
                                    .cornerRadius(10)
                                    
                                    VStack(alignment: .leading) {
                                        Text(item.title)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                        
                                        HStack {
                                            Image(systemName: "hand.thumbsup.fill")
                                            Text(String(format: "%.1f", item.vote_average))
                                            Spacer()
                                        }
                                        .foregroundColor(.yellow)
                                        .fontWeight(.heavy)
                                    }
                                    Spacer()
                                }
                                .padding()
                                .background(backgroundColor)
                                .cornerRadius(10)
                                .padding(.horizontal)
                            }
                        }
                    }
                }
            }
            .background(backgroundColorMain)
        }
        .searchable(text: $searchText)
        .preferredColorScheme(.dark)
        .onChange(of: searchText) { newValue in
            if newValue.count > 2 {
                viewModel.search(term: newValue)
            }
        }
        .onAppear {
            viewModel.loadTrending()
            viewModel.loadPopular()
        }
    }
}


#Preview {
    DiscoverView()
}
