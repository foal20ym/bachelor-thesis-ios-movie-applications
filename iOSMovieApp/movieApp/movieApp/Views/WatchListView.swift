//
//  WatchListView.swift
//  movieApp
//
//  Created by Alexander Forsanker on 3/4/24.
//

import SwiftUI

struct WatchListView: View {
    @ObservedObject var vm: MovieWatchlistViewModel
    let backgroundColorMain = Color(red:39/255, green: 40/255, blue: 59/255)
    let backgroundColor = Color(red:61/255, green: 61/255, blue: 88/255)
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(backgroundColorMain)
                if vm.watchlist.isEmpty {
                    Spacer()
                    Text("No movies in the watchlist")
                } else {
                    ScrollView {
                        LazyVStack() {
                            ForEach(vm.watchlist) { item in
                                
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
                                    
                                    HStack {
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
                                        Button {
                                            if vm.isMovieInWatchlist(movie: item) {
                                                vm.removeMovieFromWatchlist(movie: item)
                                            } else {
                                                vm.addMovieToWatchlist(movie: item)
                                            }
                                        } label: {
                                            Image(systemName: vm.isMovieInWatchlist(movie: item) ? "heart.fill" : "heart")
                                                .foregroundColor(.red)
                                        }
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
            }
            .background(backgroundColorMain)
            .preferredColorScheme(.dark)
            .navigationTitle("Watchlist")
        }
        .background(backgroundColorMain)
    }
}
