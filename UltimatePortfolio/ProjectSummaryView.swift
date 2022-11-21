//
//  ProjectSummaryView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 19.11.2022.
//

import SwiftUI

struct ProjectSummaryView: View {
	let project: Project

	var body: some View {
		VStack(alignment: .leading) {
			Text("\(project.projectItems.count) items")
				.font(.caption)
				.foregroundColor(.secondary)
			Text(project.projectTitle)
				.font(.title2)
			ProgressView(value: project.completionAmount)
				.tint(Color(project.projectColor))
		}
		.padding()
		.background(Color.secondarySystemGroupedBackground)
		.cornerRadius(10)
		.shadow(color: .black.opacity(0.2), radius: 5)
		.accessibilityElement(children: .ignore)
		.accessibilityLabel(project.label)
	}
}

struct ProjectSummaryView_Previews: PreviewProvider {
	static var previews: some View {
		ProjectSummaryView(project: Project.example)
	}
}
