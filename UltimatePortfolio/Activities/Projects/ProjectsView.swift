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

	@StateObject var viewModel: ViewModel

	var body: some View {
		NavigationStack {
			Group {
				if !viewModel.projects.isEmpty {
					projectsList
				} else {
					Text("There's nothing here right now").foregroundColor(.secondary)
				}
			}
			.navigationTitle(viewModel.showClosedProjects ? "Closed Projects" : "Open Projects")
			.toolbar {
				addProjectToolbarItem
				sortToolbarItem
			}
		}
	}

	var projectsList: some View {
		List {
			ForEach(viewModel.projects) { project in
				Section {
					ForEach(project.projectItems(using: viewModel.sortOrder)) { item in
						ItemRowView(project: project, item: item)
					}
					.onDelete { offsets in
						viewModel.deleteItem(offsets, from: project)
					}
					if !viewModel.showClosedProjects {
						Button {
							withAnimation {
								viewModel.addItem(to: project)
							}
						} label: {
							Label("Add Item", systemImage: "plus")
						}
					}
				} header: {
					ProjectHeaderView(project: project)
				} footer: {
					Text(project.projectDetail)
				}
			}
		}
	}

	var addProjectToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarTrailing) {
			if !viewModel.showClosedProjects {
				Button {
					withAnimation {
						viewModel.addProject()
					}
				} label: {
					Label("Add Project", systemImage: "plus")
				}
			}
		}
	}

	var sortToolbarItem: some ToolbarContent {
		ToolbarItem(placement: .navigationBarLeading) {
			Menu {
				Section {
					Button {
						viewModel.sortOrder = .optimized
					} label: {
						Label("Optimized", systemImage: "wand.and.stars")
					}
					Button {
						viewModel.sortOrder = .creationDate
					} label: {
						Label("Creation Date", systemImage: "calendar")
					}
					Button {
						viewModel.sortOrder = .title
					} label: {
						Label("Title", systemImage: "textformat")
					}
				} header: {
					Text("Sort")
				}
			} label: {
				Label("Sort", systemImage: "slider.horizontal.3")
			}
		}
	}

	init(dataController: DataController, showClosedProjects: Bool) {
		let viewModel = ViewModel(dataController: dataController, showClosedProjects: showClosedProjects)
		_viewModel = StateObject(wrappedValue: viewModel)
	}
}

struct ProjectsView_Previews: PreviewProvider {
	static var previews: some View {
		ProjectsView(dataController: DataController.preview, showClosedProjects: false)
	}
}
