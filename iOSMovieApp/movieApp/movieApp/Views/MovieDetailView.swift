//
//  MovieDetailView.swift
//  movieApp
//
//  Created by Alexander Forsanker on 2/28/24.
//

import SwiftUI

struct MovieDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    @StateObject var model = MovieDetailsViewModel()
    @ObservedObject var vm: MovieWatchlistViewModel
    let movie: Movie
    let headerHeight: CGFloat = 400
    let backgroundColorMain = Color(red: 39/255, green: 40/255, blue: 59/255)
    let backgroundColor = Color(red: 61/255, green: 61/255, blue: 88/255)
    
    var body: some View {
        ZStack {
            Color(red: 39/255, green: 40/255, blue: 59/255)
            
            GeometryReader { geo in
                VStack {
                    AsyncImage(url: movie.backdropURL) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: geo.size.width, maxHeight: headerHeight)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                    } placeholder: {
                        ProgressView()
                    }
                    Spacer()
                }
            }
            
            ScrollView {
                VStack(spacing: 12) {
                    Spacer()
                        .frame(height: headerHeight)
                    HStack {
                        Text(movie.title)
                            .font(.title)
                            .fontWeight(.heavy)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "hand.thumbsup.fill")
                            Text(String(format: "%.1f", movie.vote_average))
                        }
                        .foregroundColor(.yellow)
                        .fontWeight(.heavy)
                        
                        Spacer()
                        
                        Button {
                            if vm.isMovieInWatchlist(movie: movie) {
                                vm.removeMovieFromWatchlist(movie: movie)
                            } else {
                                vm.addMovieToWatchlist(movie: movie)
                            }
                        } label: {
                            Image(systemName: vm.isMovieInWatchlist(movie: movie) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                        }
                        .accessibilityIdentifier("addToWatchListButton")
                    }

                    HStack {
                        // genre tags
                        // running time
                    }
                    
                    HStack {
                        Text("About film")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        // See all buttom
                    }
                    
                    Text(movie.overview)
                        .lineLimit(2)
                        .foregroundColor(.secondary)
                    
                    HStack {
                        Text("Cast & Crew")
                            .font(.title3)
                            .fontWeight(.bold)
                        Spacer()
                        // See all buttom
                    }
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack {
                            ForEach(model.castProfiles) { cast in
                                CastView(cast: cast)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .ignoresSafeArea()
        .overlay(alignment: .topLeading) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .imageScale(.large)
                    .fontWeight(.bold)
            }
            .padding(.leading)
        }
        .toolbar(.hidden, for: .navigationBar)
        .task {
            await model.movieCredits(for: movie.id)
            await model.loadCastProfiles()
        }
    }
}
