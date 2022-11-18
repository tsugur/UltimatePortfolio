//
//  Binding-OnChange.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 28.10.2022.
//

import SwiftUI

extension Binding {
	func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
		Binding {
			self.wrappedValue
		} set: { newValue in
			self.wrappedValue = newValue
			handler()
		}
	}
}
