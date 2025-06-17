//
//  SummaryView.swift
//  ExpenseTracking
//
//  Created by Nianwen Dan on 3/2/24.
//

import SwiftUI

struct SummaryView: View {
    @ObservedObject var expenseTrackingViewModel: ExpenseTrackingViewModel
    @ObservedObject var expenseThresholdViewModel: ExpenseThresholdViewModel
    
    var body: some View {
        NavigationStack {
            Form {
                let Last7DaysSaving = expenseTrackingViewModel.getLast7DaysIncomeAndOutcome().totalSaving
                let Last7DaysSpending = expenseTrackingViewModel.getLast7DaysIncomeAndOutcome().totalSpending
                Section("Report") {
                    Text(
                        String(format: "Last 7 Days Total Saving: %.2f", Last7DaysSaving))
                    Text(
                        String(format: "Last 7 Days Total Spending: %.2f", abs(Last7DaysSpending)))
                }
                
                Section("Spending Habit") {
                    let thresholdEnable = expenseThresholdViewModel.isEnabled()
                    let isOverThreshold = expenseThresholdViewModel.isExceedExpenseThreshold(Last7DaysSpending)
                    
                    if !thresholdEnable {
                        Text("You need enable Threshold Reminder function!")
                    } else if isOverThreshold {
                        if Last7DaysSaving >= abs(Last7DaysSpending) {
                            Text("You save some good money!")
                        } else {
                            Text("You spend too much!")
                        }
                    } else {
                        Text("You have a normal budget now")
                    }
                }
            }
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SummaryView(
        expenseTrackingViewModel: ExpenseTrackingViewModel(),
        expenseThresholdViewModel: ExpenseThresholdViewModel())
}
