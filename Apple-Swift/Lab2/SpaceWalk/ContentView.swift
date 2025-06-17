//
//  ContentView.swift
//  SpaceWalk
//
//  Created by Nianwen Dan on 2/1/24.
//

import SwiftUI

struct ContentView: View {
    @State var weightOnEarth = 65
    @State var weightOnMoon = 0.0
    @State var extraWords = ""
    @State private var path = NavigationPath()
    var body: some View {
        NavigationStack(path: $path) {
            VStack {
                userInput
                Spacer()
                toMoon
                Spacer()
                Text(extraWords)
                Spacer()
//                earthIcon
                Image(.earth)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 300, height: 300, alignment: .bottomLeading)
            }
            .navigationTitle("Space Walk")
            .padding()
        }
        // MARK: TEST ONLY
//        Text("Number of Stacks: \(path.count)")
//        Text("Current Weight: \(weightOnEarth)")
        
    }
    
    var userInput: some View {
        HStack {
            Image(systemName: "figure.mixed.cardio")
            Text("Your Weight: ")
            Picker("Picker", selection: $weightOnEarth) {
                ForEach(30..<100) { weight in
                    Text("\(weight) lbs").tag(weight)
                }
            }
            .pickerStyle(.wheel)
        }
    }
    
    var toMoon: some View {
        VStack {
            NavigationLink("Go to Moon", value: "moon")
            //NavigationLink("Go to Jupiter", value: "jupiter")
        }
        .navigationDestination(for: String.self) { v in
            if v == "moon" {
                Moon(weightOnEarth: $weightOnEarth,
                     weightOnMoon: $weightOnMoon,
                     extraWords: $extraWords)
            } else { // Jupiter
                Jupiter(weightOnEarth: $weightOnEarth,
                        weightOnMoon: $weightOnMoon,
                        extraWords: $extraWords,
                        path: $path)
            }
        }
            .buttonStyle(.borderedProminent)
    }

    var earthIcon: some View {
        VStack {
            Image(.earth)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 300, height: 300, alignment: .bottomLeading)
        }
    }
}

#Preview {
    ContentView()
}
