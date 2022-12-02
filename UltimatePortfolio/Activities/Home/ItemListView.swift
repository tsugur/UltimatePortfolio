//
//  ItemListView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 18.11.2022.
//

import SwiftUI

struct ItemListView: View {
	let title: LocalizedStringKey
	let items: ArraySlice<Item>

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
					.stroke(Color(item.project?.projectColor ?? "Teal"), lineWidth: 3)
					.frame(width: 30, height: 30)
					.padding(.leading, 7)

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
		.buttonStyle(.plain)
	}
}

struct ItemListView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			VStack(alignment: .leading) {
				ItemListView(title: "Up Next", items: ArraySlice([Item.example, Item.example]))
			}
			.frame(maxWidth: .infinity, maxHeight: .infinity)
			.padding()
			.background(Color.systemGroupedBackground)
		}
	}
}
