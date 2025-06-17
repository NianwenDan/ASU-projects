//
//  ExpenseThreshold.swift
//  ExpenseTracking
//
//  Created by Nianwen Dan on 3/2/24.
//

import Foundation

struct ExpenseThreshold {
    private(set) var userExpenseThreshold: Double
    
    init() {
        self.userExpenseThreshold = 0
    }
    
    func isEnabled() -> Bool {
        if userExpenseThreshold == 0 {
            return false
        }
        return true
    }
    
    mutating func disabled() {
        userExpenseThreshold = 0
    }
    
    mutating func setExpenseThreshold(_ amount: Double) {
        userExpenseThreshold = amount
    }
}
