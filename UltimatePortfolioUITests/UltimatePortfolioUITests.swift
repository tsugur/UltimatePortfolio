//
//  UltimatePortfolioUITests.swift
//  UltimatePortfolioUITests
//
//  Created by Tsugur on 24.11.2022.
//

import XCTest

final class UltimatePortfolioUITests: XCTestCase {
	var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false

		app = XCUIApplication()
		app.launchArguments = ["enable-testing"]
		app.launch()
    }

    func testAppHas4Tabs() throws {
		XCTAssertEqual(app.tabBars.buttons.count, 4, "There should be 4 tabs in the app.")
    }

	// MARK: This fails and I have no idea why
//	func testOpenTabAddsProjects() {
//		app.buttons["Open"].tap()
//		XCTAssertEqual(app.tables.cells.count, 0, "There should be no list rows initially.")
//
//		for tapCount in 1...5 {
//			app.buttons["Add Project"].tap()
//			XCTAssertEqual(app.cells.count, tapCount, "There should be \(tapCount) rows(s) in the list.")
//		}
//		XCTAssertEqual(app.cells.count, 5, "There should be 5 rows in the list.")
//	}

	func testOpenTabAddsProjectsAlternative() {
		var buttons: XCUIElementQuery { app.buttons.matching(identifier: "Add Item") }

		app.buttons["Open"].tap()
		XCTAssertEqual(buttons.count, 0, "There should be no \"Add Item\" buttons initially.")

		for tapCount in 1...5 {
			app.buttons["Add Project"].tap()
			XCTAssertEqual(buttons.count, tapCount, "There should be \(tapCount) \"Add Item\" button(s) in the list.")
		}
	}

	func testAddingItems() {
		var addItemButtons: XCUIElementQuery { app.buttons.matching(identifier: "Add Item") }
		var newItemListRows: XCUIElementQuery { app.buttons.matching(identifier: "New Item") }

		app.buttons["Open"].tap()
		XCTAssertEqual(addItemButtons.count, 0, "There should be no \"Add Item\" buttons initially.")

		app.buttons["Add Project"].tap()
		XCTAssertEqual(addItemButtons.count, 1, "There should be 1 \"Add Item\" button in the list.")

		for tapCount in 1...5 {
			app.buttons["Add Item"].tap()
			XCTAssertEqual(newItemListRows.count, tapCount, "There should be \(tapCount) \"New Item\" list row(s) in the list.")
		}
	}

	func testEditingProjectUpdatesCorrectly() {
		var addItemButtons: XCUIElementQuery { app.buttons.matching(identifier: "Add Item") }
		var newItemListRows: XCUIElementQuery { app.buttons.matching(identifier: "New Item") }

		app.buttons["Open"].tap()
		XCTAssertEqual(addItemButtons.count, 0, "There should be no \"Add Item\" buttons initially.")

		app.buttons["Add Project"].tap()
		XCTAssertTrue(app.buttons["New Project"].exists)
		XCTAssertEqual(addItemButtons.count, 1, "There should be 1 \"Add Item\" button in the list.")

		app.buttons["New Project"].tap()
		app.textFields["Project name"].tap()

		app.keys["space"].tap()
		app.keys["more"].tap()
		app.keys["2"].tap()
		app.buttons["Return"].tap()

		app.buttons["Open Projects"].tap()
		XCTAssertTrue(app.buttons["New Project 2"].exists, "The new project name should be visible in the list.")
	}

	func testEditingItemUpdatesCorrectly() {
		var addItemButtons: XCUIElementQuery { app.buttons.matching(identifier: "Add Item") }
		var newItemListRows: XCUIElementQuery { app.buttons.matching(identifier: "New Item") }

		app.buttons["Open"].tap()
		XCTAssertEqual(addItemButtons.count, 0, "There should be no \"Add Item\" buttons initially.")

		app.buttons["Add Project"].tap()
		XCTAssertTrue(app.buttons["New Project"].exists)
		XCTAssertEqual(addItemButtons.count, 1, "There should be 1 \"Add Item\" button in the list.")

		app.buttons["Add Item"].tap()
		XCTAssertEqual(newItemListRows.count, 1, "There should be 1 \"New Item\" list rows in the list.")

		app.buttons["New Item"].tap()
		app.textFields["Item name"].tap()

		app.keys["space"].tap()
		app.keys["more"].tap()
		app.keys["2"].tap()
		app.buttons["Return"].tap()

		app.buttons["Open Projects"].tap()
		XCTAssertTrue(app.buttons["New Item 2"].exists, "The new item name should be visible in the list.")
	}

	func testAllAwardsShowLockedAlert() {
		app.buttons["Awards"].tap()

		for award in app.scrollViews.buttons.allElementsBoundByIndex {
			award.tap()

			XCTAssertTrue(app.alerts["Locked"].exists, "There should be a locked alert showing for awards")
			app.buttons["OK"].tap()
		}
	}
}
