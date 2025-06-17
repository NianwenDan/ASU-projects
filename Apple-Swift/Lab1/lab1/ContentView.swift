//
//  ContentView.swift
//  lab1
//
//  Created by Nianwen Dan on 1/19/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack (spacing: 20) {
                Spacer()
                NavigationLink(destination: part1()) {
                    Text("Part I")
                }
                NavigationLink(destination: part2()) {
                    Text("Part II")
                }
                Spacer()
            }
            .buttonStyle(.borderedProminent)
            .navigationTitle("Ideal Weight")
            .padding()
            
        }
    }
}

#Preview {
    ContentView()
}
