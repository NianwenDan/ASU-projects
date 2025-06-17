//
//  ContentView.swift
//  MainView
//
//  Created by Nianwen Dan on 3/1/24.
//

import SwiftUI

struct MainView: View {
    @StateObject var expenseTrackingViewModel = ExpenseTrackingViewModel()
    @StateObject var expenseThresholdViewModel = ExpenseThresholdViewModel()

    var body: some View {
        TabView {
            ExpenseListView(expenseTrackingViewModel: expenseTrackingViewModel,
                            expenseThresholdViewModel: expenseThresholdViewModel)
                .tabItem {
                    Label("Expenses", systemImage: "list.bullet.circle.fill")
                }
            SummaryView(expenseTrackingViewModel: expenseTrackingViewModel,
                        expenseThresholdViewModel: expenseThresholdViewModel)
                .tabItem {
                    Label("Summary", systemImage: "chart.pie")
                }
            UserView(viewModel: expenseThresholdViewModel)
                .tabItem {
                    Label("Me", systemImage: "person")
                }
        }
    }
    
}

#Preview {
    MainView()
}
