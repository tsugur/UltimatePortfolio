//
//  ItemListView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 18.11.2022.
//

import SwiftUI

struct ItemListView: View {
	let title: LocalizedStringKey
	let items: FetchedResults<Item>.SubSequence
	
    var body: some View {
		if items.isEmpty {
			EmptyView()
		} else {
			Text(title)
				.font(.headline)
				.foregroundColor(.secondary)
				.padding(.top)
			ForEach(items, content: itemRow)
		}
    }
	
	func itemRow(for item: Item) -> some View {
		NavigationLink(destination: EditItemView(item: item)) {
			HStack(spacing: 20) {
				Circle()
					.stroke(Color(item.project?.projectColor ?? "Light Blue"), lineWidth: 3)
					.frame(width: 44, height: 44)
				
				VStack(alignment: .leading) {
					Text(item.itemTitle)
						.font(.title2)
						.foregroundColor(.primary)
						.frame(maxWidth: .infinity, alignment: .leading)
					
					if !item.itemDetail.isEmpty {
						Text(item.itemDetail)
							.foregroundColor(.secondary)
					}
				}
			}
			.padding()
			.background(Color.secondarySystemGroupedBackground)
			.cornerRadius(10)
			.shadow(color: .black.opacity(0.2), radius: 5)
		}
	}
}

//struct ItemListView_Previews: PreviewProvider {
//    static var previews: some View {
//		ItemListView()
//    }
//}
