//
//  ItemRowView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 28.10.2022.
//

import SwiftUI

struct ItemRowView: View {
	@ObservedObject var project: Project
	@ObservedObject var item: Item

	var body: some View {
		NavigationLink(destination: EditItemView(item: item)) {
			HStack {
				Text(item.itemTitle)
				Spacer()
				Group {
					Text(item.priority > 2 ? "•••" : item.priority > 1 ? "••" : "•")
						.font(.headline)
					Image(systemName: item.completed ? "checkmark.circle" : "circle")
				}
				.foregroundColor(Color(project.projectColor))
			}
		}
		.accessibilityLabel(label)
	}

	var label: Text {
		if item.completed {
			return Text("\(item.itemTitle), completed.")
		} else if item.priority == 3 {
			return Text("\(item.itemTitle), high priority.")
		} else {
			return Text(item.itemTitle)
		}
	}
}

struct ItemRowView_Previews: PreviewProvider {
	static var previews: some View {
		NavigationStack {
			ItemRowView(project: Project.example, item: Item.example)
				.padding()
				.overlay {
					Rectangle()
						.stroke(.secondary.opacity(0.5))
				}
				.padding()
		}
	}
}