//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 27.10.2022.
//

import CoreData
import SwiftUI

struct HomeView: View {
	static let tag: String? = "Home"

	@EnvironmentObject var dataController: DataController

	@FetchRequest(
		entity: Project.entity(),
		sortDescriptors: [NSSortDescriptor(keyPath: \Project.title, ascending: true)],
		predicate: NSPredicate(format: "closed = false")
	) var projects: FetchedResults<Project>

	let items: FetchRequest<Item>

	var projectRows: [GridItem] {
		[GridItem(.fixed(100))]
	}

	init() {
		let request: NSFetchRequest<Item> = Item.fetchRequest()

		let completedPredicate = NSPredicate(format: "completed = false")
		let openPredicate = NSPredicate(format: "project.closed = false")
		let compoundPredicate = NSCompoundPredicate(type: .and, subpredicates: [completedPredicate, openPredicate])
		request.predicate = compoundPredicate

		request.sortDescriptors = [NSSortDescriptor(keyPath: \Item.priority, ascending: false)]
		request.fetchLimit = 10
		items = FetchRequest(fetchRequest: request)
	}

	var body: some View {
		NavigationStack {
			Group {
				if !projects.isEmpty {
					ScrollView {
						VStack(alignment: .leading) {
							ScrollView(.horizontal, showsIndicators: false) {
								LazyHGrid(rows: projectRows) {
									ForEach(projects, content: ProjectSummaryView.init)

								}
								.padding([.horizontal, .top])
								.fixedSize(horizontal: false, vertical: true)
							}
							VStack(alignment: .leading) {
								ItemListView(title: "Up next", items: items.wrappedValue.prefix(3))
								ItemListView(title: "More to explore", items: items.wrappedValue.dropFirst(3))
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
		}
	}
}

//	Button("Add Data") {
//		dataController.deleteAll()
//		try? dataController.createSampleData()
//	}
//	Button("Delete All Data") {
//		dataController.deleteAll()
//	}

struct HomeView_Previews: PreviewProvider {
	static var dataController = DataController.preview

	static var previews: some View {
		HomeView()
			.environment(\.managedObjectContext, dataController.container.viewContext)
			.environmentObject(dataController)
	}
}
