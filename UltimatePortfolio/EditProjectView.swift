//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 14.11.2022.
//

import SwiftUI

struct EditProjectView: View {
	let project: Project
	
	@EnvironmentObject var dataController: DataController
	@Environment(\.dismiss) var dismiss
	
	@State private var title: String
	@State private var detail: String
	@State private var color: String
	@State private var closed: Bool
	@State private var showingDeleteConfirm = false
	
	let colorColumns = [GridItem(.adaptive(minimum: 44))]
	
	init(project: Project) {
		self.project = project

		_title = State(wrappedValue: project.projectTitle)
		_detail = State(wrappedValue: project.projectDetail)
		_color = State(wrappedValue: project.projectColor)
		_closed = State(wrappedValue: project.closed)
	}
	
    var body: some View {
		Form {
			Section("Basic settings") {
				TextField("Project name", text: $title.onChange(update))
				TextField("Description of this project", text: $detail.onChange(update))
			}
			
			Section("Custom project color") {
				LazyVGrid(columns: colorColumns) {
					ForEach(Project.colors, id: \.self, content: colorPicker)
				}
				.padding(.vertical)
			}
			
			Section(footer: Text("Closing a project moves it from the Open to Closed tab. Deleting it removes the project completely.")) {
				Button(closed ? "Reopen this project" : "Close this project") {
					closed.toggle()
					update()
				}
				
				Button("Delete this project") {
					showingDeleteConfirm.toggle()
				}
				.accentColor(.red)
			}
		}
		.navigationTitle("Edit Project")
		.onDisappear(perform: dataController.save)
		.alert(isPresented: $showingDeleteConfirm) {
			Alert(title: Text("Delete project?"), message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), primaryButton: .default(Text("Delete"), action: delete), secondaryButton: .cancel())
		}
	}
	
	func update() {
		project.title = title
		project.detail = detail
		project.color = color
		project.closed = closed
	}
	
	func delete() {
		dataController.delete(project)
		dismiss()
	}
	
	func colorPicker(for item: String) -> some View {
		ZStack {
			Color(item)
				.aspectRatio(1, contentMode: .fit)
				.cornerRadius(6)
			if item == color {
				Image(systemName: "checkmark.circle")
					.foregroundColor(.white)
					.font(.largeTitle)
			}
		}
		.onTapGesture {
			color = item
			update()
		}
		.accessibilityElement(children: .ignore)
		.accessibilityAddTraits(
			item == color
			? [.isButton, .isSelected]
			: .isButton
		)
		.accessibilityLabel(LocalizedStringKey(item))
	}
}

struct EditProjectView_Previews: PreviewProvider {
	static var dataController = DataController.preview
	
	static var previews: some View {
		NavigationStack {
			EditProjectView(project: Project.example)
				.environment(\.managedObjectContext, dataController.container.viewContext)
				.environmentObject(dataController)
		}
	}
}
