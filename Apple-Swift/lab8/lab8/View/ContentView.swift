//
//  ContentView.swift
//  lab8
//
//  Created by Nianwen Dan on 4/11/24.
//

import SwiftUI

struct ContentView: View {
    @State var cityName: String = ""
    @State var isShowResults = false
    
    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Please enter a city name:")
                    Spacer()
                }
                TextField("Los Angeles", text: $cityName)
                    .textFieldStyle(.roundedBorder)
                NavigationLink {
                    EQEventView(cityName: cityName)
                } label: {
                    Text("Search")
                }
                .disabled(cityName == "")
                .buttonStyle(.bordered)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
