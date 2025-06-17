//
//  SearchView.swift
//  ExpenseTracking2
//
//  Created by Nianwen Dan on 4/3/24.
//

import SwiftUI
import SwiftData

struct SearchView: View {
    // Set default date range here, e.g., last 31 days
    @State var fromDate: Date = Calendar.current.date(byAdding: .day, value: -31, to: Date()) ?? Date()
    @State var toDate: Date = Date()
    
    @State var isShowResult: Bool = false
    @Binding var path: NavigationPath
    
    var body: some View {
        Form {
            Section("Date Range") {
                DatePicker("From",
                           selection: $fromDate,
                           in: ...toDate,
                           displayedComponents: [.date, .hourAndMinute]
                )
                DatePicker("To",
                           selection: $toDate,
                           in: ...Date(),
                           displayedComponents: [.date, .hourAndMinute]
                )
            }
            Button("Search") {
                isShowResult = true
            }
        }
        .navigationTitle("Search Transactions")
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $isShowResult) {
            SearchResults(fromDate: $fromDate, toDate: $toDate, path: $path)
        }
    }
}

#Preview {
    SearchView(path: .constant(NavigationPath()))
        .modelContainer(for: TransactionDetail.self)
}
