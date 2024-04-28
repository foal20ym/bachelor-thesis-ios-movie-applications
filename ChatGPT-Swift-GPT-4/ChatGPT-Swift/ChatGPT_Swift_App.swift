//
//
//  Created by XX on 2024-04-12.
//

import SwiftUI

@main
struct ChatGPTSwiftApp: App {
    var viewModel = MovieViewModel()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HomeView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                WatchlistView()
                    .tabItem {
                        Label("Watchlist", systemImage: "heart")
                    }
            }
            .environmentObject(viewModel)
        }
    }
}
