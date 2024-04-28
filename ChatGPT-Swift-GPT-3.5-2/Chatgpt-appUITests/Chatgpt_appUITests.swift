//
//  Chatgpt_appUITests.swift
//  Chatgpt-appUITests
//
//  Created by Jonathan Kilit on 2024-04-12.
//

import XCTest

final class Chatgpt_appUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric(), XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
            //measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    private func customSwipeDown(app: XCUIApplication) {
        let startCoord = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.8))
        let endCoord = app.coordinate(withNormalizedOffset: CGVector(dx: 0.5, dy: 0.2))
        let duration: TimeInterval = 0.5
        while app.staticTexts["Watchlist"].exists {
            startCoord.press(forDuration: duration, thenDragTo: endCoord)
        }
    }
    
    func testSearchWatchlistWorkflowWithAPI() throws {
        
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
            // Arrange: Launch the app
            let app = XCUIApplication()
            app.launch()
            
            // Act: Perform search
            let searchQuery = "Deadpool"
            // Tap on the search bar
            let searchBar = app.textFields["searchBar"]
            searchBar.tap()
            
            // Type "Deadpool" into the search bar
            searchBar.typeText(searchQuery)
            
            
            
            // Assert: Check if search results are displayed
            //XCTAssertTrue(app.staticTexts["\(searchQuery)"].waitForExistence(timeout: 3), "Search results for '\(searchQuery)' not found")
            
            // Act: Tap on the first search result
            app.staticTexts["\(searchQuery)"].tap()
            
            // Act: Add movie to watchlist
            app.buttons["addToWatchListButton"].tap()
            
            app.swipeDown(velocity: .fast)
            
            // Act: Go to watchlist
            let watchlistTab = app.tabBars.buttons.element(boundBy: 1)
            
            //XCTAssertTrue(watchlistTab.waitForExistence(timeout: 3), "Watchlist tab not found")
            watchlistTab.tap()
            
            // Assert: Check if watchlist screen is displayed
            //XCTAssertTrue(app.staticTexts["Watchlist"].waitForExistence(timeout: 3), "Watchlist screen not found")
            
            // Assert: Verify that the added movie is at the top of the watchlist
            XCTAssertTrue(app.staticTexts["\(searchQuery)"].isHittable, "\(searchQuery) not found at the top of watchlist")
            
            
            // Assert: Checks if watchlist screen is displayed
            //XCTAssertTrue(app.staticTexts["Watchlist"].waitForExistence(timeout: 3), "Watchlist screen not found")
            
            // Assert: Verifies that the added movie is at the top of the watchlist
            XCTAssertTrue(app.staticTexts["\(searchQuery)"].isHittable, "\(searchQuery) not found at the top of watchlist")
        }
    }
    
    func testSearchWatchlistWorkflowWithAPINoActorImages() throws {
        
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
            // Arrange: Launch the app
            let app = XCUIApplication()
            app.launch()
            
            // Act: Perform search
            let searchQuery = "Deadpool"
            // Tap on the search bar
            let searchBar = app.textFields["searchBar"]
            searchBar.tap()
            
            // Type "Deadpool" into the search bar
            searchBar.typeText(searchQuery)
            
            
            
            // Assert: Check if search results are displayed
            //XCTAssertTrue(app.staticTexts["\(searchQuery)"].waitForExistence(timeout: 3), "Search results for '\(searchQuery)' not found")
            
            // Act: Tap on the first search result
            app.staticTexts["\(searchQuery)"].tap()
            
            // Act: Add movie to watchlist
            app.buttons["addToWatchListButton"].tap()
            
            app.swipeDown(velocity: .fast)
            
            // Act: Go to watchlist
            let watchlistTab = app.tabBars.buttons.element(boundBy: 1)
            
            //XCTAssertTrue(watchlistTab.waitForExistence(timeout: 3), "Watchlist tab not found")
            watchlistTab.tap()
            
            // Assert: Check if watchlist screen is displayed
            //XCTAssertTrue(app.staticTexts["Watchlist"].waitForExistence(timeout: 3), "Watchlist screen not found")
            
            // Assert: Verify that the added movie is at the top of the watchlist
            XCTAssertTrue(app.staticTexts["\(searchQuery)"].isHittable, "\(searchQuery) not found at the top of watchlist")
            
            
            // Assert: Checks if watchlist screen is displayed
            //XCTAssertTrue(app.staticTexts["Watchlist"].waitForExistence(timeout: 3), "Watchlist screen not found")
            
            // Assert: Verifies that the added movie is at the top of the watchlist
            XCTAssertTrue(app.staticTexts["\(searchQuery)"].isHittable, "\(searchQuery) not found at the top of watchlist")
        }
    }
    
    func testScrollToEndPerformanceBothViews() throws {
            let app = XCUIApplication()
            app.launch()
            measure(metrics: [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
                let trendingScrollView = app.scrollViews["trendingScrollView"]
                let popularScrollView = app.scrollViews["popularScrollView"]
                trendingScrollView.swipeLeft(velocity: .fast)
                popularScrollView.swipeLeft(velocity: .fast)
            }
        }
}
