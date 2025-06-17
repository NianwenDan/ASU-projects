//
//  ExpenseListView.swift
//  ExpenseTracking
//
//  Created by Nianwen Dan on 3/1/24.
//

import SwiftUI

struct ExpenseListView: View {
    @ObservedObject var expenseTrackingViewModel: ExpenseTrackingViewModel
    @ObservedObject var expenseThresholdViewModel: ExpenseThresholdViewModel
    
    @State var isShowAdd = false
    
    var body: some View {
        NavigationStack {
            VStack {
                List(expenseTrackingViewModel.getLast7DaysTransactions()) { transaction in
                    ExpenseListEachCell(title: transaction.transTitle,
                                        amount: "$" + String(transaction.transAmount),
                                        date: transaction.transTimeDate.formatted(.dateTime.day().month().year()))
                }
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: { isShowAdd = true }, label: {
                    Image(systemName: "plus")
                })
            }
        }
        .sheet(isPresented: $isShowAdd, content: {
            AddNewTransView(expenseTrackingViewModel: expenseTrackingViewModel,
                            expenseThresholdViewModel: expenseThresholdViewModel,
                            isShowAdd: $isShowAdd
            )

                .presentationDetents([.fraction(0.8), .large])
                .presentationDragIndicator(.visible)
        })
    }
}

struct ExpenseListEachCell: View {
    var title: String
    var amount: String
    var date: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .lineLimit(1)
                Spacer()
                Text(amount)
            }
            .fontWeight(.bold)
            HStack {
                Text(date)
                    .font(.subheadline)
                    .foregroundStyle(Color(.gray))
                Spacer()
            }
        }
    }
}

#Preview {
    ExpenseListView(expenseTrackingViewModel: ExpenseTrackingViewModel(),
                    expenseThresholdViewModel: ExpenseThresholdViewModel())
}
