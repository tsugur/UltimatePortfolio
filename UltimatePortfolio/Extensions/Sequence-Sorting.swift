//
//  Sequence-Sorting.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 22.11.2022.
//

import Foundation

extension Sequence {
	func sorted<Value>(
		by keyPath: KeyPath<Element, Value>,
		using areInIncreasingOrder: (Value, Value) throws -> Bool
	) rethrows -> [Element] {
		try self.sorted {
			try areInIncreasingOrder($0[keyPath: keyPath], $1[keyPath: keyPath])
		}
	}
	func sorted<Value: Comparable> (by keyPath: KeyPath<Element, Value>) -> [Element] {
		self.sorted(by: keyPath, using: <)
	}
}
