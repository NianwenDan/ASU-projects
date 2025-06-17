//
//  UserSettings.swift
//  ExpenseTracking2
//
//  Created by Nianwen Dan on 4/4/24.
//

import Foundation
import SwiftData

@Model
class UserSettings: Identifiable {
    var expenseThreshold: Double
    var isEnableExpenseThreshold: Bool
    
    @Attribute(.unique) var id: Int
    
    init(expenseThreshold: Double, isEnableExpenseThreshold: Bool, id: Int) {
        self.expenseThreshold = expenseThreshold
        self.isEnableExpenseThreshold = isEnableExpenseThreshold
        self.id = id
    }
}
