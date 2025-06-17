//
//  ExpenseThresholdViewModel.swift
//  ExpenseTracking
//
//  Created by Nianwen Dan on 3/2/24.
//

import Foundation

class ExpenseThresholdViewModel: ObservableObject {
    @Published private var model = ExpenseThreshold()
    
    func isEnabled() -> Bool {
        model.isEnabled()
    }
    
    func setExpenseThreshold(_ userExpenseThreshold: String, isEnabled: Bool) {
        model.setExpenseThreshold(Double(userExpenseThreshold) ?? 0.0)
        if !isEnabled {
            model.disabled()
        }
        print("User Expense Threshold: \(model.userExpenseThreshold)")
    }
    
    func isExceedExpenseThreshold(_ balance: Double) -> Bool {
        if model.isEnabled() && -balance > model.userExpenseThreshold {
            return true
        }
        return false
    }
}
