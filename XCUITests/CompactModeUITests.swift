/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import XCTest

class CompactModeUITests: BaseTestCase {
        
    var navigator: Navigator!
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        app = XCUIApplication()
        navigator = createScreenGraph(app).navigator(self)
    }
    
    override func tearDown() {
        navigator = nil
        app = nil
        super.tearDown()
    }
    
    //Set the compact mode to OFF in settings screen
    private func compactModeOff() {
        let app = XCUIApplication()
        app.buttons["TabTrayController.menuButton"].tap()
        app.collectionViews.cells["SettingsMenuItem"].tap()
        app.tables["AppSettingsTableViewController.tableView"].switches["Use Compact Tabs"].tap()
        app.navigationBars["Settings"].buttons["AppSettingsTableViewController.navigationItem.leftBarButtonItem"].tap()
    }
    
    //Set the compact mode to ON in settings screen
    private func compactModeOn() {
        app.buttons["TabTrayController.menuButton"].tap()
        app.collectionViews.cells["SettingsMenuItem"].tap()
        app.tables["AppSettingsTableViewController.tableView"].switches["Use Compact Tabs"].tap()
        app.navigationBars["Settings"].buttons["AppSettingsTableViewController.navigationItem.leftBarButtonItem"].tap()
    }
    
    //Opens a new tab
    private func openNewTab() {
        app.buttons["URLBarView.tabsButton"].tap()
        app.buttons["TabTrayController.addTabButton"].tap()
        app.collectionViews.cells["TopSitesCell"].collectionViews.containing(.cell, identifier:"TopSite").element.tap()
    }
    
    //Enters the url in the browser tab
    private func enterAndOpenUrl(url: String) {
        app.textFields["url"].tap()
        waitforExistence(app.textFields["address"])
        app.textFields["address"].typeText(url)
        app.buttons["Go"].tap()
    }
    
    func testCompactModeUI() {
        //Dsimiss intro screen
        dismissFirstRunUI()

        //Creating array of 6 urls
        let urls: [String] = [
            "www.google.com",
            "www.facebook.com",
            "www.youtube.com",
            "www.amazon.com",
            "www.twitter.com",
            "www.yahoo.com"
        ]

        //Open the array of urls in 6 different tabs
        for i in 0..<urls.count {
            if i > 0 {
                openNewTab()
            }
            enterAndOpenUrl(url: urls[i])
        }

        //Navigate to tabs tray
        navigator.goto(TabTray)
      
        //CollectionView visible cells count should be 6
        XCTAssertTrue(app.collectionViews.cells.countForHittables == 6)

        compactModeOff()

        //CollectionView visible cells count should be less than or equal to 4
        XCTAssertTrue(app.collectionViews.cells.countForHittables <= 4)
        
        compactModeOn()

        //CollectionView visible cells count should be 6
        XCTAssertTrue(app.collectionViews.cells.countForHittables == 6)
    }
}

extension XCUIElementQuery {
    var countForHittables: UInt {
        return UInt(allElementsBoundByIndex.filter { $0.isHittable }.count)
    }
}
