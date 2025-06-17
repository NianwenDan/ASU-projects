//
//  ExpenseTrackingViewModel.swift
//  ExpenseTracking
//
//  Created by Nianwen Dan on 3/1/24.
//

import Foundation

class ExpenseTrackingViewModel: ObservableObject {
    @Published private var model = ExpenseTracking()
    
    func save(transTitle: String, transType: ExpenseType, transAmount: String, transTimeDate: Date, transDescription: String) {
        // TODO: Check Value Type
        var transAmount = abs(Double(transAmount) ?? 0.0)
        transAmount = setTransAmountPercision(transAmount)
        transAmount = setTransAmountType(transType, transAmount)
        
        model.add(transTitle: transTitle,
                  transAmount: transAmount,
                  transTimeDate: transTimeDate,
                  transDescription: transDescription)
        print(model.expenses)
        print(model.balance)
    }
    
    func enableSave(constrains: Array<String>) -> Bool {
        for constrain in constrains {
            if constrain == "" {
                return false
            }
        }
        return true
    }
    
    func getBalance() -> Double {
        model.balance
    }
    
    func getLast7DaysTransactions() -> Array<ExpenseTracking.transactionDetail> {
        model.getXDaysTrans(days: 7).reversed()
    }
    
    func getLast7DaysIncomeAndOutcome() -> (totalSpending: Double, totalSaving: Double) {
        let last7DaysTransaction = model.getXDaysTrans(days: 7)
        var totalSpending: Double = 0.0
        var totalSaving: Double = 0.0
        
        for transaction in last7DaysTransaction {
            let transAmount = transaction.transAmount
            if transAmount > 0 {
                totalSaving += transAmount
            } else {
                totalSpending += transAmount
            }
        }
        return (totalSpending, totalSaving)
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
