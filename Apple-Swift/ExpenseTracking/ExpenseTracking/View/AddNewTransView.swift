//
//  AddNewTransView.swift
//  ExpenseTracking
//
//  Created by Nianwen Dan on 3/1/24.
//

import SwiftUI

struct AddNewTransView: View {
    @ObservedObject var expenseTrackingViewModel: ExpenseTrackingViewModel
    @ObservedObject var expenseThresholdViewModel: ExpenseThresholdViewModel
    
    @Binding var isShowAdd: Bool
    @State var isShowAlert: Bool = false
    
    @State var transTitle = ""
    @State var transType = ExpenseType.spending
    @State var transAmount = ""
    @State var transTimeDate = Date.now
    @State var transDescription = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Title") {
                    TextField("Title", text: $transTitle)
                }
                
                Section("Detail") {
                    Picker("Type", selection: $transType) {
                        ForEach(ExpenseType.allCases, id: \.self) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    TextField("Amount in USD", text: $transAmount)
                    DatePicker("Date",
                               selection: $transTimeDate,
                               displayedComponents: .date
                    )
                }
                
                Section("Note") {
                    TextField("Description", text: $transDescription)
                }
            }
            .navigationTitle("Add New Transaction")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button("Add") {
                    expenseTrackingViewModel.save(transTitle: transTitle,
                                   transType: transType,
                                   transAmount: transAmount,
                                   transTimeDate: transTimeDate,
                                   transDescription: transDescription
                    )
                    // Show Alert If Over the Set OverThread
                    let totalSpendingIn7Days = expenseTrackingViewModel.getLast7DaysIncomeAndOutcome().totalSpending
                    if transType == .spending && expenseThresholdViewModel.isExceedExpenseThreshold(totalSpendingIn7Days) {
                        isShowAlert = true
                    }
                    
                    if !isShowAlert {
                        isShowAdd = false
                    }
                }
                .disabled(!expenseTrackingViewModel.enableSave(constrains: [transTitle, transAmount]))
            }
        }
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Expense Threshold Exceed"),
                  message: Text("Your account balance has exceed over your setting!"),
                  dismissButton: .default(Text("OK")) { isShowAdd = false }
            )
        }
    }
}

#Preview {
    AddNewTransView(expenseTrackingViewModel: ExpenseTrackingViewModel(), expenseThresholdViewModel: ExpenseThresholdViewModel(),
                    isShowAdd: .constant(false))
}
