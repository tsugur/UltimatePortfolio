//
//  PerformanceTests.swift
//  UltimatePortfolioTests
//
//  Created by Tsugur on 23.11.2022.
//

import XCTest
@testable import UltimatePortfolio

final class PerformanceTests: BaseTestCase {
	func testAwardCalculationPerformance() throws {
		// Create a significant amount of test data
		for _ in 1...100 {
			try dataController.createSampleData()
		}

		// Simulate lots of awards to check
		let awards = Array(repeating: Award.allAwards, count: 25).joined()
		XCTAssertEqual(awards.count, 500, "This checks the number of awards is constant. Change this if you add more awards.")

		measure {
			_ = awards.filter(dataController.hasEarned)
		}
	}
}
