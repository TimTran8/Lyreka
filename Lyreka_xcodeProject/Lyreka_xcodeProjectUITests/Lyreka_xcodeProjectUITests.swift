//
//  Lyreka_xcodeProjectUITests.swift
//  Lyreka_xcodeProjectUITests
//
//  Created by Osama Elsamny on 2018-11-04.
//  Copyright © 2018 Li heng Ou. All rights reserved.
//

import XCTest

class Lyreka_xcodeProjectUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testintOptionButton() {
        let app = XCUIApplication()
        app.buttons["Settings"].tap()
        app.navigationBars["Settings"].buttons["Back"].tap()
    }
    func testingPlayButton(){
        let app = XCUIApplication()
        app.buttons["Play"].tap()
        app.navigationBars["PlayList"].buttons["Back"].tap()
    }
    func testingPlayingSong(){
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        app.buttons["Play"].tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Yesterday Once More"]/*[[".cells.staticTexts[\"Yesterday Once More\"]",".staticTexts[\"Yesterday Once More\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(10)
        
        
        let pauseButton = app.navigationBars.buttons["Pause"]
        pauseButton.tap()
        
        let playlistButton = app.buttons["Playlist"]
        playlistButton.tap()
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["Fly Me To The Moon"]/*[[".cells.staticTexts[\"Fly Me To The Moon\"]",".staticTexts[\"Fly Me To The Moon\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(15)
        
        pauseButton.tap()
        playlistButton.tap()
        app.navigationBars["PlayList"].buttons["Back"].tap()
        
    }
    
    func testingSocrePOPMenu(){
        
        let app = XCUIApplication()
        app.buttons["Play"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Fly Me To The Moon"]/*[[".cells.staticTexts[\"Fly Me To The Moon\"]",".staticTexts[\"Fly Me To The Moon\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(15)
        app.buttons["fall"].tap()
        sleep(25)
        app.buttons["sing"].tap()
        sleep(15)
        app.navigationBars.buttons["Pause"].tap()
        sleep(1)
        app.buttons["Resume"].tap()
        sleep(90)
        app.buttons["Playlist"].tap()
        app.navigationBars["PlayList"].buttons["Back"].tap()
        
    }
    
    func testingPlayAgainPOPMenu(){
        let app = XCUIApplication()
        app.buttons["Play"].tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Fly Me To The Moon"]/*[[".cells.staticTexts[\"Fly Me To The Moon\"]",".staticTexts[\"Fly Me To The Moon\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        sleep(15)
        app.buttons["fall"].tap()
        sleep(25)
        app.buttons["sing"].tap()
        sleep(15)
        app.navigationBars.buttons["Pause"].tap()
        sleep(1)
        app.buttons["Resume"].tap()
        sleep(90)
        app.buttons["Play Again"].tap()
        sleep(20)
        app.navigationBars.buttons["Pause"].tap()
        sleep(1)
        app.buttons["Playlist"].tap()
        app.navigationBars["PlayList"].buttons["Back"].tap()
    }
    
}
