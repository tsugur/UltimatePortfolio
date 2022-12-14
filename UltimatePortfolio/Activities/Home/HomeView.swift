//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 27.10.2022.
//

import CoreData
import CoreSpotlight
import SwiftUI

struct HomeView: View {
	static let tag: String? = "Home"
	@StateObject var viewModel: ViewModel

	var projectRows: [GridItem] {
		[GridItem(.fixed(100))]
	}

	init(dataController: DataController) {
		let viewModel = ViewModel(dataController: dataController)
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	var body: some View {
		NavigationStack(path: $viewModel.path) {
			Group {
				if !viewModel.projects.isEmpty {
					ScrollView {
						if let item = viewModel.selectedItem {
//							NavigationLink(
//								destination: EditItemView(item: item),
//								tag: item,
//								selection: $viewModel.selectedItem,
//								label: EmptyView.init
//							)
//							.id(item)

							NavigationLink(value: item, label: EmptyView.init)
								.id(item)
								.navigationDestination(for: Item.self) { item in
									EditItemView(item: item)
								}
						}
						VStack(alignment: .leading) {
							ScrollView(.horizontal, showsIndicators: false) {
								LazyHGrid(rows: projectRows) {
									ForEach(viewModel.projects, content: ProjectSummaryView.init)

								}
								.padding([.horizontal, .top])
								.fixedSize(horizontal: false, vertical: true)
							}
							VStack(alignment: .leading) {
								ItemListView(title: "Up next", items: viewModel.upNext)
								ItemListView(title: "More to explore", items: viewModel.moreToExplore)
							}
							.padding(.horizontal)
						}
					}
					.background(Color.systemGroupedBackground)
				} else {
					Text("Your active projects will appear here")
						.foregroundColor(.secondary)
						.font(.title2)
				}
			}
			.navigationTitle("Home")
			.toolbar {
				Button("Add Data", action: viewModel.addSampleData)
				Button("Delete All", action: viewModel.dataController.deleteAll)
			}
			.onContinueUserActivity(CSSearchableItemActionType, perform: loadSpotlightItem)
		}
	}

	func loadSpotlightItem(_ userActivity: NSUserActivity) {
		if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
			viewModel.selectItem(with: uniqueIdentifier)
		}
	}
}

struct HomeView_Previews: PreviewProvider {
	static var previews: some View {
		HomeView(dataController: .preview)
	}
}
