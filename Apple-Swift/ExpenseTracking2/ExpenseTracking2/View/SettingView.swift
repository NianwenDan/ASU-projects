//
//  SettingView.swift
//  ExpenseTracking2
//
//  Created by Nianwen Dan on 4/4/24.
//

import SwiftUI
import SwiftData

struct SettingView: View {
    @Query var userSetting: [UserSettings]
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss
    
    @Binding var isShowSetting: Bool
    @State var userID = 1
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
                save()
                isShowSetting = false
                
            }
        }
        .navigationTitle("User Setting")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let setting = userSetting.first(where: { $0.id == userID }) {
                isThresholdReminderEnabled = setting.isEnableExpenseThreshold
                userExpenseThreshold = String(setting.expenseThreshold)
            }
        }
    }
    func save() {
        modelContext.insert(UserSettings(expenseThreshold: Double(userExpenseThreshold) ?? 0.0,
                                         isEnableExpenseThreshold: isThresholdReminderEnabled,
                                         id: userID))
        dismiss()
    }
}

#Preview {
    SettingView(isShowSetting: .constant(true))
}
