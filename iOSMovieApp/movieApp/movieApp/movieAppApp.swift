//
//  movieAppApp.swift
//  movieApp
//
//  Created by Alexander Forsanker on 2/15/24.
//

import SwiftUI

@main
struct MovieAppApp: App {
    @StateObject var vm = MovieWatchlistViewModel()
    var body: some Scene {
        WindowGroup {
            TabView {
                DiscoverView(vm: vm)
                    .tabItem {
                        Image(systemName: "popcorn")
                    }
                WatchListView(vm: vm)
                    .tabItem {
                        Image(systemName: "heart.fill")
                    }
            }
        }
    }
}
