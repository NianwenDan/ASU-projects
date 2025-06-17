//
//  AddNewTransView.swift
//  ExpenseTracking2
//
//  Created by Nianwen Dan on 4/3/24.
//

import SwiftUI
import SwiftData

struct AddNewTransView: View {
    @Environment(\.modelContext) var modelContext
    @Query var transactions: [TransactionDetail] // Read all objects from the SwiftData database
    @Query var userSetting: [UserSettings]
    
    @Binding var path: NavigationPath
    @State var isShowAlert = false
    
    @State var transTitle = ""
    @State var transType = ExpenseType.spending
    @State var transAmount = ""
    @State var transTimeDate = Date.now
    @State var transDescription = ""
    
    var body: some View {
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
                           displayedComponents: [.date, .hourAndMinute]
                )
            }
            
            Section("Note") {
                TextField("Description", text: $transDescription, axis: .vertical)
            }
            Section("Current Account Balance: $" + String(calculateBalance())) {
                
            }
        }
        .navigationTitle("New Transaction")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            Button("Save") {
                let result = add()
                if !result {
                    isShowAlert = true
                }
            }
            .disabled(transTitle == "" || transAmount == "")
        }
        .alert(isPresented: $isShowAlert) {
            Alert(title: Text("Expense Threshold Exceed"),
                  message: Text("Your account balance has exceed over your setting!"),
                  dismissButton: .default(Text("OK")) { isShowAlert = false }
            )
        }
    }
    
    func add() -> Bool {
        // TODO: Check Value Type
        var transAmount = abs(Double(transAmount) ?? 0.0)
        transAmount = setTransAmountPercision(transAmount)
        transAmount = setTransAmountType(transType, transAmount)
        
        let transaction = TransactionDetail(title: transTitle,
                                            amount: transAmount,
                                            timeDate: transTimeDate,
                                            desc: transDescription)
        if let setting = userSetting.first(where: { $0.id == 1 }) {
            if setting.isEnableExpenseThreshold && -calculateBalance()-transAmount > setting.expenseThreshold {
                return false
            }
        }
        modelContext.insert(transaction)
        path.removeLast()
        return true
    }
    
    private func calculateBalance() -> Double {
        var balance = 0.0
        for t in transactions {
            balance += t.amount
        }
        return balance
    }
    
    private func setTransAmountPercision(_ value: Double) -> Double {
        round(value * 100) / 100.0
    }
    
    private func setTransAmountType (_ transType: ExpenseType, _ value: Double) -> Double {
        switch transType {
        case .spending:
            return -value
        case .saving:
            return value
        }
    }
}

#Preview {
    AddNewTransView(path: .constant(NavigationPath()))
        .modelContainer(for: TransactionDetail.self)
}
