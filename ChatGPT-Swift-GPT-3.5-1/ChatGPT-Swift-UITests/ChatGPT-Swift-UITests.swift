//
//
//  Created by XX on 2024-03-27.
//

import XCTest

final class ChatGPTSwiftUITests: XCTestCase {
    
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
    
    func testLaunchPerformance1() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric(), XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
            //measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testLaunchPerformance15Iterations1() throws {
        
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
            
            let searchView = app.tabBars.buttons.element(boundBy: 1)
            
            app.searchFields["Search"].tap()
            let searchQuery = "Deadpool"
            
            app.searchFields["Search"].typeText(searchQuery)
            
            XCTAssertTrue(app.scrollViews.otherElements.staticTexts[searchQuery].waitForExistence(timeout: 4))
        }
    }
    
    func testSearchWatchlistWorkflowAPI() throws {
        measure(metrics: [XCTCPUMetric(), XCTMemoryMetric(), XCTClockMetric()]) {
            let app = XCUIApplication()
            app.launch()
            app.buttons["searchTab"].tap()
            let searchQuery = "Deadpool"
            // Tap on the search bar
            let searchBar = app.textFields["searchBar"]
            searchBar.tap()
            
            // Type "Deadpool" into the search bar
            searchBar.typeText(searchQuery)
            
            // Find the search button by traversing the view hierarchy
            let searchButton = app.buttons.matching(identifier: "Search").firstMatch
            XCTAssertTrue(searchButton.waitForExistence(timeout: 5), "Search button not found")
            
            // Tap the search button
            searchButton.tap()
            
            // Tap on the first result
            app.staticTexts["\(searchQuery)"].tap()

            // Add the movie to the watchlist
            app.buttons["Add to Watchlist"].tap()
            
            app.navigationBars.buttons.element(boundBy: 0).tap()
            
            // Go to the watchlist view
            app.buttons["watchListTab"].tap()
            
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
