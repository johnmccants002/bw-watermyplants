//
//  WaterMyPlantsUITests.swift
//  WaterMyPlantsUITests
//
//  Created by John McCants on 2/24/21.
//

import XCTest

class WaterMyPlantsUITests: XCTestCase {

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

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
    
    func testCreatePlantWithoutImage() throws {
        
        let app = XCUIApplication()
        app.activate()
        app.navigationBars["Plants"].buttons["Add"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element(boundBy: 0).tap()
        
        let textField = element.children(matching: .textField).element(boundBy: 1)
        textField.tap()
        textField.tap()
        app/*@START_MENU_TOKEN@*/.buttons["Twice a day"]/*[[".segmentedControls.buttons[\"Twice a day\"]",".buttons[\"Twice a day\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.navigationBars["Add Plant"].buttons["Save"].tap()
                
    }
    
    func testCreatePlantWithImage() throws {
        
        let app = XCUIApplication()
        app.activate()
        app.navigationBars["Plants"].buttons["Add"].tap()
        
        let element = app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element
        element.children(matching: .textField).element(boundBy: 0).tap()
        
        let textField = element.children(matching: .textField).element(boundBy: 1)
        textField.tap()
        textField.tap()
        
        app/*@START_MENU_TOKEN@*/.buttons["Thrice a day"]/*[[".segmentedControls.buttons[\"Thrice a day\"]",".buttons[\"Thrice a day\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app/*@START_MENU_TOKEN@*/.staticTexts["Add Photo"]/*[[".buttons[\"Add Photo\"].staticTexts[\"Add Photo\"]",".staticTexts[\"Add Photo\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        app.scrollViews.otherElements.images["Photo, March 30, 2018, 12:14 PM"].tap()

        
    }
}
