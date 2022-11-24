//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 27.10.2022.
//

import SwiftUI

struct ProjectsView: View {
	static let openTag: String? = "Open"
	static let closedTag: String? = "Closed"

	@EnvironmentObject var dataController: DataController
	@Environment(\.managedObjectContext) var managedObjectContext

	@State private var sortOrder = Item.SortOrder.optimized

	let showClosedProjects: Bool

	let projects: FetchRequest<Project>

	init(showClosedProjects: Bool) {
		self.showClosedProjects = showClosedProjects

		projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [
			NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)
		], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
	}

	var body: some View {
		NavigationStack {
			Group {
				if !projects.wrappedValue.isEmpty {
					projectsList
				} else {
					Text("There's nothing here right now").foregroundColor(.secondary)
				}
			}
			.navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
			.toolbar {
				addProjectToolbarItem
				sortToolbarItem
			}
		}
	}

	var projectsList: some View {
		List {
			ForEach(projects.wrappedValue) { project in
				Section {
					ForEach(project.projectItems(using: sortOrder)) { item in
						ItemRowView(project: project, item: item)
					}
					.onDelete { offsets in
						deleteItem(offsets, from: project)
					}
					if !showClosedProjects {
						Button {
							addItem(to: project)
						} label: {
							Label("Add Item", systemImage: "plus")
						}
					}
				} header: {
					ProjectHeaderView(project: project)
				}
			}
		}
	}

	var addProjectToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			if !showClosedProjects {
				Button {
					addProject()
				} label: {
					Label("Add Project", systemImage: "plus")
				}
			}
		}
	}

	var sortToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Menu {
				Text("Sort")
				Button {
					sortOrder = .optimized
				} label: {
					Label("Optimized", systemImage: "wand.and.stars")
				}
				Button {
					sortOrder = .creationDate
				} label: {
					Label("Creation Date", systemImage: "calendar")
				}
				Button {
					sortOrder = .title
				} label: {
					Label("Title", systemImage: "textformat")
				}
			} label: {
				Label("Sort", systemImage: "slider.horizontal.3")
			}
		}
	}

	func addProject() {
		withAnimation {
			let project = Project(context: managedObjectContext)
			project.closed = false
			project.creationDate = Date()
			dataController.save()
		}
	}

	func addItem(to project: Project) {
		withAnimation {
			let item = Item(context: managedObjectContext)
			item.project = project
			item.creationDate = Date()
			dataController.save()
		}
	}

	func deleteItem(_ offsets: IndexSet, from project: Project) {
		let allItems = project.projectItems(using: sortOrder)

		for offset in offsets {
			let item = allItems[offset]
			dataController.delete(item)
		}

		dataController.save()
	}
}

struct ProjectsView_Previews: PreviewProvider {
	static var dataController = DataController.preview

	static var previews: some View {
		ProjectsView(showClosedProjects: false)
			.environment(\.managedObjectContext, dataController.container.viewContext)
			.environmentObject(dataController)
	}
}
