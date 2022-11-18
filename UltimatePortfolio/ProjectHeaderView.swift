//
//  ProjectHeaderView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 28.10.2022.
//

import SwiftUI

struct ProjectHeaderView: View {
	@ObservedObject var project: Project
	
    var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(project.completionAmount == 1 ? "\(project.projectTitle) – Completed" : project.projectTitle)
				ProgressView(value: project.completionAmount)
					.tint(Color(project.projectColor))
			}
			Spacer()
			NavigationLink (destination: EditProjectView(project: project)) {
				Image(systemName: "square.and.pencil")
					.imageScale(.large)
					.foregroundColor(.secondary)
			}
		}
		.padding(.bottom, 10)
		.accessibilityElement(children: .combine)
    }
}

struct ProjectHeaderView_Previews: PreviewProvider {
    static var previews: some View {
		ProjectHeaderView(project: Project.example)
    }
}
