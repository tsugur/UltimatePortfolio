//
//  AwardsView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 17.11.2022.
//

import SwiftUI

struct AwardsView: View {
	static let tag: String? = "Awards"

	@EnvironmentObject var dataController: DataController
	@State private var selectedAward = Award.example
	@State private var showingAwardsDetails = false

	var columns = [GridItem(.adaptive(minimum: 100, maximum: 100))]

	var body: some View {
		NavigationStack {
			ScrollView {
				LazyVGrid(columns: columns, alignment: .center) {
					ForEach(Award.allAwards) { award in
						Button {
							selectedAward = award
							showingAwardsDetails = true
						} label: {
							Image(systemName: award.image)
								.resizable()
								.scaledToFit()
								.padding()
								.frame(width: 100, height: 100)
								.foregroundColor(color(for: award))
						}
						.accessibilityLabel(accessibilityLabel(for: award))
						.accessibilityHint(Text(award.description))
					}
				}
			}
			.navigationTitle("Awards")
		}
		.alert(alertLabel(for: selectedAward), isPresented: $showingAwardsDetails) { } message: {
			Text(selectedAward.description)
		}
	}

	func color(for award: Award) -> Color {
		dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5)
	}

	func accessibilityLabel(for award: Award) -> Text {
		Text(dataController.hasEarned(award: award) ? "Unlocked: \(award.name)" : "Locked")
	}

	func alertLabel(for award: Award) -> LocalizedStringKey {
		dataController.hasEarned(award: selectedAward) ? "Unlocked: \(selectedAward.name)" : "Locked"
	}
}

struct AwardsView_Previews: PreviewProvider {
	static var dataController = DataController.preview

	static var previews: some View {
		NavigationStack {
			AwardsView()
				.environmentObject(dataController)
		}
	}
}
