//
//  EditProjectView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 14.11.2022.
//

import CoreHaptics
import SwiftUI

struct EditProjectView: View {
	@ObservedObject var project: Project

	@EnvironmentObject var dataController: DataController
	@Environment(\.dismiss) var dismiss

	@State private var title: String
	@State private var detail: String
	@State private var color: String
	@State private var closed: Bool
	@State private var showingDeleteConfirm = false

	@State private var engine = try? CHHapticEngine()

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

			// swiftlint:disable:next line_length
			Section(footer: Text("Closing a project moves it from the Open to Closed tab. Deleting it removes the project completely.")) {
				Button(closed ? "Reopen this project" : "Close this project", action: toggleClosed)

				Button("Delete this project") {
					showingDeleteConfirm.toggle()
				}
				.accentColor(.red)
			}
		}
		.navigationTitle("Edit Project")
		.onDisappear(perform: dataController.save)
		.alert(isPresented: $showingDeleteConfirm) {
			Alert(
				title: Text("Delete project?"),
				message: Text("Are you sure you want to delete this project? You will also delete all the items it contains."), // swiftlint:disable:this line_length
				primaryButton: .default(Text("Delete"), action: delete),
				secondaryButton: .cancel()
			)
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

	func toggleClosed() {
		closed.toggle()
		update()

		if project.closed {
			do {
				try engine?.start()

				let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0)
				let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 1)

				let start = CHHapticParameterCurve.ControlPoint(relativeTime: 0, value: 1)
				let end = CHHapticParameterCurve.ControlPoint(relativeTime: 1, value: 0)

				let parameter = CHHapticParameterCurve(
					parameterID: .hapticIntensityControl,
					controlPoints: [start, end],
					relativeTime: 0
				)

				let event1 = CHHapticEvent(
					eventType: .hapticTransient,
					parameters: [intensity, sharpness],
					relativeTime: 0
				)
				let event2 = CHHapticEvent(
					eventType: .hapticContinuous,
					parameters: [intensity, sharpness],
					relativeTime: 0.125,
					duration: 1
				)

				let pattern = try CHHapticPattern(events: [event1, event2], parameterCurves: [parameter])

				let player = try engine?.makePlayer(with: pattern)
				try player?.start(atTime: 0)
			} catch {
				// playing haptics didn't work, but that's okay!
			}
		}
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
