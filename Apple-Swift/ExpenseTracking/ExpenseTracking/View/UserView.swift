//
//  UserView.swift
//  ExpenseTracking
//
//  Created by Nianwen Dan on 3/2/24.
//

import SwiftUI

struct UserView: View {
    @ObservedObject var viewModel: ExpenseThresholdViewModel
    
    @State var isThresholdReminderEnabled: Bool = false
    @State var userExpenseThreshold: String = ""
    
    var body: some View {
        Form {
            Section("Threshold Reminder") {
                Toggle("Enable Threshold Reminder", isOn: $isThresholdReminderEnabled)
                if isThresholdReminderEnabled {
                    TextField("limit", text: $userExpenseThreshold)
                }
            }
            Button("Save Setting") {
                viewModel.setExpenseThreshold(userExpenseThreshold, isEnabled: isThresholdReminderEnabled)
            }
        }
    }
}

#Preview {
    UserView(viewModel: ExpenseThresholdViewModel())
}
