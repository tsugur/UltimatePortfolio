//
//  ProjectsViewModel.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 27.11.2022.
//

import CoreData
import Foundation
import SwiftUI

extension ProjectsView {
	class ViewModel: NSObject, ObservableObject, NSFetchedResultsControllerDelegate {
		let dataController: DataController

		@Published var sortOrder = Item.SortOrder.optimized
		let showClosedProjects: Bool

		private let projectController: NSFetchedResultsController<Project>
		@Published var projects = [Project]()

		init(dataController: DataController, showClosedProjects: Bool) {
			self.dataController = dataController
			self.showClosedProjects = showClosedProjects

			let request: NSFetchRequest<Project> = Project.fetchRequest()
			request.sortDescriptors = [NSSortDescriptor(keyPath: \Project.creationDate, ascending: false)]
			request.predicate = NSPredicate(format: "closed = %d", showClosedProjects)

			projectController = NSFetchedResultsController(
				fetchRequest: request,
				managedObjectContext: dataController.container.viewContext,
				sectionNameKeyPath: nil,
				cacheName: nil
			)

			super.init()
			projectController.delegate = self

			do {
				try projectController.performFetch()
				projects = projectController.fetchedObjects ?? []
			} catch {
				print("Failed to add our projects!")
			}
		}

		func addProject() {
				let project = Project(context: dataController.container.viewContext)
				project.closed = false
				project.creationDate = Date()
				dataController.save()
		}

		func addItem(to project: Project) {
				let item = Item(context: dataController.container.viewContext)
				item.project = project
				item.creationDate = Date()
				dataController.save()
		}

		func deleteItem(_ offsets: IndexSet, from project: Project) {
			let allItems = project.projectItems(using: sortOrder)

			for offset in offsets {
				let item = allItems[offset]
				dataController.delete(item)
			}

			dataController.save()
		}

		func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
			if let newProjects = controller.fetchedObjects as? [Project] {
				projects = newProjects
			}
		}
	}
}
