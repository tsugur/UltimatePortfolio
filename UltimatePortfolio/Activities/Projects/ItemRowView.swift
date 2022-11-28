//
//  ItemRowView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 28.10.2022.
//

import SwiftUI

struct ItemRowView: View {
	@StateObject var viewModel: ViewModel

//	@ObservedObject var project: Project
	@ObservedObject var item: Item

	init(project: Project, item: Item) {
		let viewModel = ViewModel(project: project, item: item)
		_viewModel = StateObject(wrappedValue: viewModel)
//		_project = ObservedObject(wrappedValue: project)
		_item = ObservedObject(wrappedValue: item)
	}

	var body: some View {
		NavigationLink(destination: EditItemView(item: item)) {
			HStack {
				Text(item.itemTitle)
				Spacer()
				Group {
					Text(viewModel.icon.priority)
						.font(.headline)
					Image(systemName: viewModel.icon.completion)
				}
				.foregroundColor(Color(viewModel.color))
			}
		}
		.accessibilityLabel(viewModel.label)
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
