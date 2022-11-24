//
//  UltimatePortfolioTests.swift
//  UltimatePortfolioTests
//
//  Created by Tsugur on 21.11.2022.
//

import CoreData
import XCTest
@testable import UltimatePortfolio

class BaseTestCase: XCTestCase {
	var dataController: DataController!
	var managedObjectContext: NSManagedObjectContext!

	override func setUpWithError() throws {
		dataController = DataController(inMemory: true)
		managedObjectContext =  dataController.container.viewContext
	}

}
