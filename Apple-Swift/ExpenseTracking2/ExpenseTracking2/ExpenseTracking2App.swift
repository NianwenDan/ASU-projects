//
//  ExpenseTracking2App.swift
//  ExpenseTracking2
//
//  Created by Nianwen Dan on 4/3/24.
//

import SwiftData
import SwiftUI

@main
struct ExpenseTracking2App: App {
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: [TransactionDetail.self, UserSettings.self])
    }
}
