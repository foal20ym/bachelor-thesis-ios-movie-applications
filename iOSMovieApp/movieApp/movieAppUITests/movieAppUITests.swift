//
//  movieAppUITests.swift
//  movieAppUITests
//
//  Created by Alexander Forsanker on 3/25/24.
//

import XCTest

final class movieAppUITests: XCTestCase {
    
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
                XCUIApplication().launch()
            }
        }
    }
    
    func testLaunchPerformance15Iterations() throws {
        
        let option = XCTMeasureOptions()
        option.iterationCount = 15
        
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            self.measure(metrics: [XCTApplicationLaunchMetric(), XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()], options: option) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testSearchFunctionality() throws {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
            let app = XCUIApplication()
            app.launch()
        
            app.searchFields["Search"].tap()
            let searchQuery = "Deadpool"

            app.searchFields["Search"].typeText(searchQuery)
  
            XCTAssertTrue(app.scrollViews.otherElements.staticTexts[searchQuery].waitForExistence(timeout: 4))
        }
    }

    func testSearchWatchlistWorkflowWithJSONData() throws {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
            // Arrange: Launch the app
            let app = XCUIApplication()
            app.launch()
            
            // Act: Perform search
            app.searchFields["Search"].tap()
            let searchQuery = "Deadpool"
            app.searchFields["Search"].typeText(searchQuery)
            
            // Act: Tap on the first search result
            app.staticTexts["\(searchQuery)"].tap()
            
            // Act: Add movie to watchlist
            app.buttons["addToWatchListButton"].tap()
            
            // Act: Go to watchlist
            let watchlistTab = app.tabBars.buttons.element(boundBy: 1)
            
            //XCTAssertTrue(watchlistTab.waitForExistence(timeout: 3), "Watchlist tab not found")
            watchlistTab.tap()
            
            // Assert: Verify that the added movie is at the top of the watchlist
            XCTAssertTrue(app.staticTexts["\(searchQuery)"].isHittable, "\(searchQuery) not found at the top of watchlist")
            
            // Assert: Verifies that the added movie is at the top of the watchlist
            XCTAssertTrue(app.staticTexts["\(searchQuery)"].isHittable, "\(searchQuery) not found at the top of watchlist")
        }
    }
    
    func testSearchWatchlistWorkflowWithAPI() throws {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
            // Arrange: Launch the app
            let app = XCUIApplication()
            app.launch()
            
            // Act: Perform search
            app.searchFields["Search"].tap()
            let searchQuery = "Deadpool"
            app.searchFields["Search"].typeText(searchQuery)
            
            // Act: Tap on the first search result
            app.staticTexts["\(searchQuery)"].tap()
            
            // Act: Add movie to watchlist
            app.buttons["addToWatchListButton"].tap()
            
            // Act: Go to watchlist
            let watchlistTab = app.tabBars.buttons.element(boundBy: 1)
    
            watchlistTab.tap()
            
            // Assert: Verify that the added movie is at the top of the watchlist
            XCTAssertTrue(app.staticTexts["\(searchQuery)"].isHittable, "\(searchQuery) not found at the top of watchlist")
            
            // Assert: Verifies that the added movie is at the top of the watchlist
            XCTAssertTrue(app.staticTexts["\(searchQuery)"].isHittable, "\(searchQuery) not found at the top of watchlist")
        }
    }
    
    func testScrollToEndPerformance() throws {
        let app = XCUIApplication()
        app.launch()
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
            let trendingScrollView = app.scrollViews["trendingScrollView"]
            trendingScrollView.swipeLeft(velocity: .fast)
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
