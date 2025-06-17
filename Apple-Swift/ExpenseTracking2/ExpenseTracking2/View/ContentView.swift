//
//  ContentView.swift
//  ExpenseTracking2
//
//  Created by Nianwen Dan on 4/3/24.
//

import SwiftData
import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    @Query var transactions: [TransactionDetail] // Read all objects from the SwiftData database
    
    @State var isShowAddNewTrans = false
    @State var isShowSetting = false
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(transactions) { transaction in
                    ExpenseListEachCell(title: transaction.title,
                                        amount: "$ \(transaction.amount)",
                                        date: transaction.timeDate.formatted())
                }
                .onDelete(perform: deleteTrans)
            }
            .navigationTitle("Transactions")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(value: "Show Search") {
                        Image(systemName: "magnifyingglass.circle")
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(value: "Show Add") {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button(action: {
                        isShowSetting = true
                    }, label: {
                        Image(systemName: "gear")
                    })
                }
            }
            .navigationDestination(for: String.self) { value in
                if value == "Show Search" {
                    SearchView(path: $path)
                } else if value == "Show Add" {
                    AddNewTransView(path: $path)
                }
            }
            .navigationDestination(isPresented: $isShowSetting, destination: {
                SettingView(isShowSetting: $isShowSetting)
            })
        }
    }
    
    func addSamples() {
        let trans1 = TransactionDetail(title: "Trans1", amount: 2.34, timeDate: .now, desc: "")
        let trans2 = TransactionDetail(title: "Trans2", amount: 100.2, timeDate: .now, desc: "")
        let trans3 = TransactionDetail(title: "Trans3", amount: 21.43, timeDate: .now, desc: "")
        
        modelContext.insert(trans1)
        modelContext.insert(trans2)
        modelContext.insert(trans3)
    }
    
    func deleteTrans(_ indexSet: IndexSet) {
        for index in indexSet {
            let transaction = transactions[index]
            modelContext.delete(transaction)
        }
    }
}

struct ExpenseListEachCell: View {
    var title: String
    var amount: String
    var date: String
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text(title)
                    .lineLimit(1)
                Spacer()
                Text(amount)
            }
            .fontWeight(.bold)
            HStack {
                Text(date)
                    .font(.subheadline)
                    .foregroundStyle(Color(.gray))
                Spacer()
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [TransactionDetail.self, UserSettings.self])
}
