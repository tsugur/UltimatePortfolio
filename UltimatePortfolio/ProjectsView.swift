//
//  ProjectsView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 27.10.2022.
//

import SwiftUI

struct ProjectsView: View {
	let showClosedProjects: Bool
	
	let projects: FetchRequest<Project>
	
	init(showClosedProjects: Bool) {
		self.showClosedProjects = showClosedProjects
		
		projects = FetchRequest<Project>(entity: Project.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)], predicate: NSPredicate(format: "closed = %d", showClosedProjects))
	}
	
    var body: some View {
		NavigationStack {
			List {
				ForEach(projects.wrappedValue) { project in
					Section(project.title ?? "") {
						ForEach(project.items?.allObjects as? [Item] ?? []) { item in
							Text(item.title ?? "")
						}
					}
				}
			}
			.navigationTitle(showClosedProjects ? "Closed Projects" : "Open Projects")
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
