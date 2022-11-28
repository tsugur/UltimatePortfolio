//
//  ItemRowViewModel.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 28.11.2022.
//

import Foundation

extension ItemRowView {
	class ViewModel: ObservableObject {
		let project: Project
		let item: Item

		var title: String {
			item.itemTitle
		}

		var icon: (priority: String, completion: String) {
			var priority: String { item.priority > 2 ? "•••" : item.priority > 1 ? "••" : "•" }
			var completion: String { item.completed ? "checkmark.circle" : "circle" }
			return (priority, completion)
		}

		var color: String {
			project.projectColor
		}

		var label: String {
			if item.completed {
				return "\(item.itemTitle), completed."
			} else if item.priority == 3 {
				return "\(item.itemTitle), high priority."
			} else {
				return item.itemTitle
			}
		}

		init(project: Project, item: Item) {
			self.project = project
			self.item = item
		}
	}
}
