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
								.foregroundColor(dataController.hasEarned(award: award) ? Color(award.color) : Color.secondary.opacity(0.5))
						}
					}
				}
			}
			.navigationTitle("Awards")
		}
		.alert(dataController.hasEarned(award: selectedAward) ? "Unlocked: \(selectedAward.name)" : "Locked", isPresented: $showingAwardsDetails) { } message: {
			Text(selectedAward.description)
		}
	}
}

struct AwardsView_Previews: PreviewProvider {
	static var dataController = DataController.preview
	
    static var previews: some View {
        NavigationStack{
        	AwardsView()
				.environmentObject(dataController)
        }
    }
}
