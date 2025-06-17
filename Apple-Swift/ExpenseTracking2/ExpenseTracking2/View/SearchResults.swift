//
//  SearchResults.swift
//  ExpenseTracking2
//
//  Created by Nianwen Dan on 4/3/24.
//

import SwiftUI
import SwiftData

struct SearchResults: View {
    @Query var transactions: [TransactionDetail] // Read all objects from the SwiftData database
    
    @Binding var fromDate: Date
    @Binding var toDate: Date
    @Binding var path: NavigationPath
    
    var filteredTransactions: [TransactionDetail] {
        transactions.filter { transaction in
                (transaction.timeDate >= fromDate && transaction.timeDate <= toDate)
        }
    }
    var body: some View {
        VStack {
            if filteredTransactions.isEmpty {
                Spacer()
                Text("No Transactions Found")
                Spacer()
            }
        }
        List {
            ForEach(filteredTransactions) { transaction in
                ExpenseListEachCell(title: transaction.title,
                                    amount: "$ \(transaction.amount)",
                                    date: transaction.timeDate.formatted())
            }
        }
        .navigationTitle("Search Results")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    SearchResults(fromDate: .constant(.now), toDate: .constant(.now), path: .constant(NavigationPath()))
        .modelContainer(for: TransactionDetail.self)
}
