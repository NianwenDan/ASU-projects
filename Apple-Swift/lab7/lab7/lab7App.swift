//
//  lab7App.swift
//  lab7
//
//  Created by Nianwen Dan on 3/31/24.
//

import SwiftUI
import SwiftData

@main
struct lab7App: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            City.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(sharedModelContainer)
        }
    }
}
