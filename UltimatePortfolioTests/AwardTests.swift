//
//  AwardTests.swift
//  UltimatePortfolioTests
//
//  Created by Tsugur on 22.11.2022.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

final class AwardTests: BaseTestCase {
	let awards = Award.allAwards

	func testAwardIDMatchesName() {
		for award in awards {
			XCTAssertEqual(award.id, award.name, "Award ID should always match its name.")
		}
	}

	func testNewUserHasNoAwards() {
		for award in awards {
			XCTAssertFalse(dataController.hasEarned(award: award), "New users should have no earned awards")
		}
	}

	func testAddingItems() {
		let values = [1, 10, 20, 50, 100, 250, 500, 1000]

		for (count, value) in values.enumerated() {
			for _ in 0..<value {
				_ = Item(context: managedObjectContext)
			}

			let matches = awards.filter { award in
				award.criterion == "items" && dataController.hasEarned(award: award)
			}

			XCTAssertEqual(matches.count, count+1, "Adding \(value) should unlock \(count+1) awards")

			dataController.deleteAll()
		}
	}

	func testCompletingItems() {
		let values = [1, 10, 20, 50, 100, 250, 500, 1000]

		for (count, value) in values.enumerated() {
			var items = [Item]()

			for _ in 0..<value {
				let item = Item(context: managedObjectContext)
				item.completed = true
				items.append(item)
			}

			let matches = awards.filter { award in
				award.criterion == "complete" && dataController.hasEarned(award: award)
			}

			XCTAssertEqual(matches.count, count+1, "Completing \(value) should unlock \(count+1) awards")

			for item in items {
				dataController.delete(item)
			}

			print(matches.count)
			print(count+1)
		}
	}
}
