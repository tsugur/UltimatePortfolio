//
//  HomeView.swift
//  UltimatePortfolio
//
//  Created by Tsugur on 27.10.2022.
//

import SwiftUI

struct HomeView: View {
	@EnvironmentObject var dataController: DataController
	
    var body: some View {
		NavigationStack {
			VStack {
				Button("Add Data") {
					dataController.deleteAll()
					try? dataController.createSampleData()
				}
			}
			.navigationTitle("Home")
		}
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
