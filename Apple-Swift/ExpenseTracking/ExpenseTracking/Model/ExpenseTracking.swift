//
//  ExpenseTracking.swift
//  ExpenseTracking
//
//  Created by Nianwen Dan on 3/1/24.
//

import Foundation

struct ExpenseTracking {
    private(set) var expenses: Array<transactionDetail>
    private(set) var balance: Double
    
    init() {
        self.expenses = []
        self.balance = 0
        addTestData()
    }
    
    private mutating func addTestData() {
        let calendar = Calendar.current
        for day in (0...29).reversed() {
            guard let transTimeDate = calendar.date(byAdding: .day, value: -day, to: Date()) else { continue }
            
            let transTitle = "Test Transaction\(day+1)"
            let transAmount = round(Double.random(in: -100...100) * 100) / 100.0
            let transDescription = "Description for transaction \(day+1)"
            
            add(transTitle: transTitle, transAmount: transAmount, transTimeDate: transTimeDate, transDescription: transDescription)
        }
    }
    
    mutating func add(transTitle: String, transAmount: Double, transTimeDate: Date, transDescription: String) {
        balance += transAmount
        expenses.append(
            transactionDetail(transTitle: transTitle,
                              transAmount: transAmount,
                              transTimeDate: transTimeDate,
                              transDescription: transDescription
                             )
        )
    }
    
    func remove() {
        // TODO
    }
    
    func update() {
        // TODO
    }
    
    func search() {
        // TODO
    }
    
    func getXDaysTrans(days: Int) -> [ExpenseTracking.transactionDetail] {
        let calendar = Calendar.current
        let currentDate = Date()
        let dateXDaysAgo = calendar.date(byAdding: .day, value: -days, to: currentDate)!
        
        // Only show last X days transactions
        let expensesInXDays = expenses.filter { transaction in
            return transaction.transTimeDate >= dateXDaysAgo
        }
        
        return expensesInXDays
    }
    
    struct transactionDetail: Identifiable, CustomDebugStringConvertible {
        //var currencyType: String
        
        
        var transTitle: String
        var transAmount: Double
        var transTimeDate: Date
        var transDescription: String
        
        var id = UUID()
        var debugDescription: String {
            "\(id): \(transTitle) \(transAmount) \(transTimeDate) \(transDescription) \n"
        }
    }
}
