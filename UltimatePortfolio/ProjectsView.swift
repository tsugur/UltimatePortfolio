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
			List {
				ForEach(projects.wrappedValue) { project in
					Section {
						ForEach(project.projectItems(using: sortOrder)) { item in
							ItemRowView(project: project, item: item)
						}
						.onDelete { offsets in
							let allItems = project.projectItems(using: sortOrder)
							
							for offset in offsets {
								let item = allItems[offset]
								dataController.delete(item)
							}
							
							dataController.save()
						}
						if !showClosedProjects {
							Button {
								withAnimation {
									let item = Item(context: managedObjectContext)
									item.project = project
									item.creationDate = Date()
									dataController.save()
								}
							} label: {
								Label("Add Item", systemImage: "plus")
							}
						}
					} header: {
						ProjectHeaderView(project: project)
					}
				}
			}
			.navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
			.toolbar {
				ToolbarItem(placement: .navigationBarTrailing) {
					if !showClosedProjects {
						Button {
							withAnimation {
								let project = Project(context: managedObjectContext)
								project.closed = false
								project.creationDate = Date()
								dataController.save()
							}
						} label: {
							Label("Add Project", systemImage: "plus")
						}
					}
				}
				ToolbarItem(placement: .navigationBarLeading) {
					Menu() {
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
		}
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
