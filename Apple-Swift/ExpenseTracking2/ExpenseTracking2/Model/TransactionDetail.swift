//
//  TransactionDetail.swift
//  ExpenseTracking2
//
//  Created by Nianwen Dan on 4/3/24.
//

import Foundation
import SwiftData

@Model
class TransactionDetail: Identifiable {
    var title: String
    var amount: Double
    var timeDate: Date
    var desc: String
    
    let id: UUID
    
    init(title: String, amount: Double, timeDate: Date, desc: String) {
        self.title = title
        self.amount = amount
        self.timeDate = timeDate
        self.desc = desc
        
        self.id = UUID()
    }
}
